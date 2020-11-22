#!/bin/bash
# consolidate merged annotations, run over curated/*

# required input column structure:
# ID WORD (from CDLI)
# ID WORD SEGM POS MORPH HEAD EDGE MISC (from ETSCRI, force-merged, i.e., +-connected sub-token annotations, use this as basis for SEGM)
# ID WORD SEGM POS MORPH HEAD EDGE MISC (from ETSCRI, levenshtein-merged, i.e., using closest CDLI match, use this as basis for POS, MORPH, HEAD and DEP)
# ID GLOSS POS HEAD EDGE (from annotation projection, use this as basis for HEAD and DEP in combination with ETSCRI)

# output column structure:
# ID (from CDLI)
# WORD (from CDLI)
# SEGM (from force-merged ETCSRI, if available; fallback: (1) levenshtein-merged ETCSRI, (2) normalized gloss (from annotation projection)
# POS (from levenshtein-merged ETCSRI, if available; fallback: normalized POS (from annotation projection)
# MORPH (from levenshtein-merged ETSCRI, if available; fallback: POS)
# HEAD (from levenshtein-merged ETSCRI, complemented with annotation projection)
# EDGE (see HEAD)
# MISC indicate source of *dependency* annotation (E: ETSCRI pre-annotation, A: annotation projection, R: revoked annotation projection)
#      if manual annotation applied to the output files, replace MISC by _

#########
# input #
# files #
#########

FILES=curated/*.conll
if echo $* | egrep '[a-zA-Z0-9]' >&/dev/null; then
	FILES=$*
fi;

#############
#  output   #
# directory #
#############

# to write conll to
MRG=consolidated
if [ ! -d $MRG ]; then mkdir -p $MRG; fi

# to write grammar vis to
DEBUG=debug
if [ ! -d $DEBUG ]; then mkdir -p $DEBUG; fi

##########
# config #
##########

# set to your local CoNLL-Merge installation or get it from http://github.com/acoli-repo/conll
MERGE=~/conll/cmd/merge.sh

# set to your local CoNLL-RDF installation or get it from http://github.com/acoli-repo/conll-rdf
CONLL_RDF=~/conll-rdf
LOAD=$CONLL_RDF/run.sh" CoNLLStreamExtractor '#' "
TRANSFORM=$CONLL_RDF/run.sh" CoNLLRDFUpdater -custom "
WRITE=$CONLL_RDF/run.sh" CoNLLRDFFormatter"

#############
# integrate #
#############

for file in $FILES; do
	src=$file;
	tgt=$MRG/`basename $file`
	dbg=$DEBUG/`basename $file | sed s/'\..*'//`.log
	echo $tgt 1>&2
	if [ -s $tgt ]; then
		echo $tgt found, skipping 1>&2
		echo 1>&2
	else
		(egrep -v '# tr.en: txt' $file | \
		# $TRANSFORM -updates\
		$LOAD \
				_ WORD \
				_ _ SEGM _ _ _ _ _ \
				EL_ID _ EL_SEGM POS MORPH EL_HEAD EL_EDGE _ \
				EN_ID GLOSS EN_POS EN_HEAD EN_EDGE \
			-u \
				drop-unused.sparql \
				consolidate-segm.sparql \
				consolidate-pos.sparql \
				normalize-deps.sparql \
				consolidate-deps.sparql \
				consolidate-wrapup.sparql \
			| \
		$WRITE -conll ID WORD SEGM POS MORPH HEAD EDGE MISC > $tgt
		) 2>&1 | tee $dbg 1>&2
		if [ -s $tgt ]; then 
			echo $tgt ok 1>&2;
			echo 1>&2
		else 
			echo $tgt failed 1>&2; rm $tgt; 
			echo 1>&2
			cat $dbg 1>&2
			echo 1>&2
		fi
	fi;
	
done;

#############
# visualize #
#############

for file in $MRG/*; do
	dbg_ttl=$DEBUG/`basename $file | sed s/'\..*'//`.ttl.vis
	dbg_txt=$DEBUG/`basename $file | sed s/'\..*'//`.txt
	echo $file ">" $dbg_ttl, $dbg_txt 1>&2
	cat $file | \
	$LOAD ID WORD SEGM POS MORPH HEAD EDGE MISC |\
	$WRITE -debug -grammar 2>$dbg_ttl 1>$dbg_txt
done

#########
# close #
#########

echo done 1>&2

#!/bin/bash
# merge automated morphological annotation (morph/) with projected annotations (sux_projected) and normalize the result

# required input column structure:
# morph: WORD SEGM POS MORPH MISC (MORPH inference strategy)
# sux_projected: ID	WORD TRANSLATION E_POS HEAD E_EDGE

# output column structure:
# ID (from projection)
# WORD (from morph)
# SEGM (from morph; [TRANSLATION] if not available)
# POS (from morph, if available; fallback: normalized E_POS (from projection)
# MORPH (from morph; fallback: POS)
# HEAD (from projection)
# EDGE (from projection, normalized)
# MISC indicate source of *dependency* annotation: A: annotation projection
#      if manual annotation applied to the output files, replace MISC by _

#########
# input #
# files #
#########

SUX=sux_projected/
MORPH=morph/
FILES=`cd $SUX; find | grep 'conll$'`				# productive mode, for debugging options, see parameters below
FILES=`for FILE in $FILES; do
	if [ -e $MORPH/$FILE ]; then echo $FILE ; fi; done`
	
#############
#  output   #
# directory #
#############

# to write conll to
MRG=merged/
OUT=consolidated/

# to write grammar vis to
DEBUG=debug/

##############
# parameters #
##############

# -clean: delete output directories before running
if echo $* | egrep -i '\-clean' >& /dev/null; then
	echo cleaning 1>&2
	rm -rf $MRG $OUT $DEBUG
fi;

# -debug: delete output directories and process a single file only
if echo $* | egrep -i '\-debug' >&/dev/null; then
	echo debugging mode 1>&2
	rm -rf $MRG $OUT $DEBUG
	#FILES=`echo $FILES | sed s/'\s'/'\n'/g | egrep 'conll$' | head -n 1`
	FILES=dev/P101274.conll
fi;

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

########
# prep #
########

for DIR in $MRG $OUT $DEBUG; do
	if [ ! -d $DIR ]; then mkdir -p $DIR; fi
	for dir in `echo $FILES | sed s/'\s'/'\n'/g | egrep '\/' | sed s/'\/[^\/]*$'//g | uniq`; do
		if [ ! -e $dir ]; then
			mkdir -p $DIR/$dir
		fi
	done;
done

##############
# processing #
##############

for file in $FILES; do
	if [ -e $OUT/$file ]; then
		echo $OUT/$file found, keeping it 1>&2
	else
		echo > $OUT/$file
		if [ ! -s $MRG/$file ]; then
		
	#########
	# merge #
	#########
		
			sux=`realpath --relative-to=. $SUX/$file`
			morph=`realpath --relative-to=. $MORPH/$file`
			if [ -s $sux ]; then
				if [ -s $morph ]; then
					tmp_sux=`basename $sux`.sux.tmp
					tmp_morph=`basename $morph`.morph.tmp
					cat $sux | egrep '^[0-9]' > $tmp_sux
					cat $morph | egrep '\s' | egrep -v '^(#|FORM)' > $tmp_morph

					# fast, purely positional alignment
					if [ `cat $tmp_sux | wc -l` = `cat $tmp_morph | wc -l` ]; then
						(cat $sux | egrep -v '^[0-9]';
						 paste $tmp_sux $tmp_morph) > $MRG/$file
						rm $tmp_sux $tmp_morph
					else
						echo alignment error: length mismatch for $sux "("`cat $tmp_sux | wc -l`")" and $morph "("`cat $tmp_morph | wc -l`")" 1>&2;
					
						echo -n $MRG/$file' ' 1>&2
						( 	# timeout
							cmdpid=$BASHPID; 
							(sleep 90; kill $cmdpid >& /dev/null) & 
							# merge with conll-merge:
							
							# this one is more robust against changes, but it
							# occasionally hangs up for unknown reason (process spawning failed???)
							$MERGE $sux $morph 1 0 -lev -drop none| egrep '^[#0-9]' | \
							perl -pe 's/\?/_/g; s/(#.*[^_\s])[\s_]*\n/$1\n/g;'  \
							> $MRG/$file 
							# intermediate output
							# ID WORD TRANSLATION E_POS HEAD E_EDGE	WORD SEGM POS MORPH MISC
							)
						
						if [ -s $MRG/$file ]; then
							echo ok 1>&2
						else
							echo failed 1>&2
							if [ -e $MRG/$file ]; then rm $MRG/$file; fi
						fi;
					fi;
				fi;
			fi;
			echo
		fi;
		
	#############
	# integrate #
	#############
		if [ -s $MRG/$file ]; then
			cat $MRG/$file | \
			$LOAD ID WORD TRANSLATION EN_POS HEAD EN_EDGE	_ SEGM POS MORPH _ \
				-u \
					drop-unused.sparql \
					consolidate-segm.sparql  \
					consolidate-pos.sparql  \
					normalize-deps.sparql   \
					consolidate-deps.sparql \
					consolidate-wrapup.sparql | \
			$WRITE -conll ID WORD SEGM POS MORPH HEAD EDGE MISC > $OUT/$file
			echo -n $OUT/$file' ' 1>&2
			if [ ! -s $OUT/$file ]; then
				echo failed 1>&2
				rm $OUT/$file
			else
				echo ok 1>&2;

	#############
	# visualize #
	#############

				(dbg_ttl=$DEBUG/`echo $file | sed s/'\.[^\.]*$'//`.ttl.vis
				dbg_txt=$DEBUG/`echo $file | sed s/'\.[^\.]*$'//`.txt
				echo $OUT/$file ">" $dbg_ttl, $dbg_txt 1>&2
				cat $OUT/$file | \
				$LOAD ID WORD SEGM POS MORPH HEAD EDGE MISC |\
				$WRITE -debug -grammar 2>$dbg_ttl 1>$dbg_txt) &
			fi
		fi
	fi;
done

#########
# close #
#########

echo done 1>&2

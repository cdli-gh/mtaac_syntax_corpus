#!/bin/bash
# split all atf files given as args

echo "synopsis: "$0' [-clean] FILE1[..n].atf' 1>&2
echo "  FILEi.atf CDLI ATF file with English translations (i.e., lines marked by '#tr.en')" 1>&2
echo "            get it from https://github.com/cdli-gh/mtaac_cdli_ur3_corpus/tree/master/ur3_corpus_data/atf (Ur III corpus)," 1>&2
echo "            from https://github.com/cdli-gh/data (full corpus), or" 1>&2 
echo "            from https://cdli.ucla.edu/ (search interface with export function)" 1>&2
echo "            Note that this data must be pre-filtered to identify translated Sumerian texts, for the Ur III corpus, see " 1>&2
echo "            https://github.com/cdli-gh/mtaac_cdli_ur3_corpus/raw/master/ur3_corpus_data/corpus_split_translated_20180514-125709.json" 1>&2
echo "  -clean    delete all generated files prior to running the script, necessary if the script is called with different argument( files)" 1>&2
echo 1>&2
echo "  Uses annotation projection from English to bootstrap a syntactically annotated corpus of cuneiform languages (for manual refinement)." 1>&2
echo "  See the CONFIG section of this script for dependencies." 1>&2
echo "  Note that the script is configured to *not* overwrite/update its output and auxiliary files, use the -clean option to produce annotations" 1>&2
echo "  for a different selection of source files (the old corpus will be deleted)." 1>&2
echo 1>&2

##########
# CONFIG #
##########

# GIZA++, set to your executables or get them from https://github.com/moses-smt/giza-pp
PLAIN2SNT_OUT=plain2snt.out
MKCLS=mkcls
GIZA=GIZA++

# Stanford Core NLP, set to your corenlp.sh or get it from https://stanfordnlp.github.io/CoreNLP/
# (don't get confused by my local alias here, this normally should be $YOUR_STANFORD_PATH/corenlp.sh)
STANFORD=stanford

# CoNLL-Merge, set to your merge.sh or get it from https://github.com/acoli-repo/conll-merge
CONLL_MERGE=~/conll/cmd/merge.sh 

# set to your Python exec, designed for Python 3.x
PYTHON=python3.7

# set to your CoNLL-RDF root directory or get it from https://github.com/acoli-repo/conll-rdf
CONLL_RDF=~/conll-rdf/
# do not touch
LOAD=$CONLL_RDF/run.sh" CoNLLStreamExtractor http://ignore.me/ "
UPDATE=$CONLL_RDF/run.sh" CoNLLRDFUpdater -custom -updates "
WRITE=$CONLL_RDF/run.sh" CoNLLRDFFormatter "

###########
# PRUNING #
###########

# -clean flag
if echo $1 | grep "^-clean$" >& /dev/null; then
	# (1) files generated by this script
	# (2) GIZA++-generated files
	echo cleaning auxiliary and output files 1>&2;
	for file in \
		sux eng \
		*.raw *.raw.* \
		sux_eng.* eng_sux.* \
		eng.* eng-norm.* \
		\
		*final \
		*.Decoder.config \
		*.gizacfg \
		*.perp \
		*.vcb *.vcb.* \
		*.snt \
		sux_projected/ sux_eng/ \
	; do
		if [ -e $file ]; then
			echo '  'remove $file 1>&2
			rm -rf $file
		fi;
	done;
	echo 1>&2
	
	# drop -clean flag
	shift
fi;

# run only with valid file parameters
if echo $1 | egrep '.' >&/dev/null; then
	echo "executing "$0 $* 1>&2
	echo 1>&2
	if [ ! -f $1 ]; then	# we check the first only (must exist as a file, but may be empty)
		echo "Error: Didn't find "$1", make sure this is a readable ATF file" 1>&2;
	else

		#############
		# PREP DATA #
		#############

		echo -n "extraction .. " 1>&2
		if [ -s sux ]; then
			echo "skipped (found sux)" 1>&2;
		else
			for file in $*; do
				echo $file >> sux
				echo >> sux
				egrep -B 1 -a '^#tr.en:' $file | \
				egrep -A 1 -a '^[0-9]' | \
				egrep '^[0-9]' | sed s/'^[0-9\.]* *'// >> sux;
				echo >> sux
				
				echo $file >> eng
				echo >> eng
				egrep -B 1 -a '^#tr.en:' $file | \
				egrep -A 1 -a '^[0-9]' | \
				egrep '^#tr.en:' | sed s/'^#[^:]*: *'// >> eng;
				echo >> eng
				
			done;
			if [ -s sux ]; then
				echo ok 1>&2
			else
				echo failed 1>&2 # must not be empty
			fi;
		fi;

		# normalize (for alignment)
		echo -n "normalization .. " 1>&2

			# do not overwrite *raw files (= final textual data)
			for file in *; do
				if [ -s $file.raw ]; then mv $file.raw $file; fi;
			done;

			sed -i.raw \
				-e s/'\t'/' '/g \
				-e s/'[#]'//g \
				-e s/'\['//g \
				-e s/'\]'//g \
				-e s/'\([ \-]\)\.\.\.\([ \-]\)'/'\1x\2'/g \
				-e s/'\([ \-]\)\.\.\.$'/'\1x'/g \
				-e s/'^\.\.\.\([ \-]\)'/'x\1'/g \
				-e s/'\?'//g \
				-e s/'^[0-9][^ ]*'/'CARD'/g \
				-e s/' [0-9][^ ]*'/' CARD'/g sux
				
			# also remove punctuation and determiner the
			sed -i.raw \
				-e s/'[“”]'/'"'/g \
				-e s/"[‘’]"/"'"/g \
				-e s/'[—]'/'-'/g \
				-e s/'[!\?]'/'.'/g \
				-e s/'[\[<{]'/'('/g \
				-e s/'[\]>}]'/')'/g \
				-e s/'\+'//g \
				-e s/'…'/'...'/g \
				-e s/'[ṭ]'/'t'/g \
				-e s/'[ìî]'/'i'/g \
				-e s/'ē'/'e'/g \
				-e s/'[ûũ]'/'u'/g \
				-e s/'Ḫ'/'H'/g \
				-e s/'Ø'/'0'/g \
				-e s/'æ'/'a'/g \
				-e s/'&'/' and '/g \
				-e s/'ř'/'r'/g \
				-e s/'ĝ'/'g'/g \
				-e s/'ŝ'/'sz'/g \
				-e s/'Š'/'Sz'/g \
				-e s/'([^)]*)'/' '/g \
				-e s/'([^)]*)'/' '/g \
				-e s/'\([a-zA-Z]\)\([“”,."‘’!:\/;]\)\([^a-zA-Z]\)'/'\1 \2 \3'/g \
				-e s/'\([^a-zA-Z]\)\([,."!:\/;“”‘’]\)\([a-zA-Z]\)'/'\1 \2 \3'/g \
				-e s/'[^a-zA-ZŠ -][^a-zA-ZŠ -]*'//g \
				-e s/' [Tt]he '/' '/g \
				-e s/'  *'/' '/g eng
			# NB: characters in eng
			# [\sa-zA-Z0-9/\.\-:,;“Š‘’”)ṢīḪāūé'—\[\]ṭ\?<>îēũḪ\+ìØ…"!æû&řĝŝ{}]

			cat eng | sed \
				-e s/'^[0-9][^ ]*'/'CARD'/g \
				-e s/' [0-9][^ ]*'/' CARD'/g \
				> eng.card

		if [ -s sux ]; then
			echo ok 1>&2
		else
			echo failed 1>&2 # must not be empty
		fi;

		###########
		# PARSING #
		###########
		
		echo -n "parsing .. " 1>&2
		if [ -s eng.conllu ]; then
			echo "skipped (found eng.conllu)" 1>&2
		else
			(cat eng.raw | \
			 # "functional replacements": replace elements unprocessable by the parser with conceptually similar (not equivalent) expressions 
			 # it is likely to be able to process
			 # rendering unreadable as "something" will help to produce valid parses
			 sed -e s/'\.\.\.'/'something'/g -e s/'xxx'/'something'/g | \
			 perl -pe '	# common units, as fed to parser, see http://cdli.ox.ac.uk/wiki/doku.php?id=ur_iii_metrological_systems for actual values
				# this does not improve parse quality, still analyzed as "compound"
				# # s/ (shekel|shekels|mina|minas|mana|manas|talent|talents) / kg /g;
				# # s/ (sila3|sila|ban3|ban3|barig|gur) / liter /g;
				# # s/ (ninda) / meter /g;
				# # s/ (sar|ubu|iku|esze|esze3|eše3|eše|bur3|šar2|šar) / hectare /g;
				s/ n / 5 /g;	
				s/^n /5 /g;
				s/ n$/ 5/g;
				' | \
			 perl -pe 's/^$/<br>/g; s/\n/ /g; s/<br>/\n/g; while(m/\([^\)]*\)/) { s/\([^\)]*\)/ /g }; s/   */ /g;' | \
			 # -ssplit.eolonly: suppress sentence splitting (this will lead to duplicate word IDs otherwise
			 $STANFORD -annotators tokenize,ssplit,pos,lemma,depparse -ssplit.eolonly -outputFormat conllu > eng.psd.conllu 2>eng.conllu.log #&	## now non-parallelized, not stable, just run sequentially
			 )
			 # echo started 1>&2	# parallelized
			 echo ok 1>&2			# non-parallelized, now
			 
			(cat eng.raw | \
			 perl -pe 's/^$/<br>/g; s/\n/ /g; s/<br>/\n/g; while(m/\([^\)]*\)/) { s/\([^\)]*\)/ /g }; s/   */ /g;' | \
			 perl -pe 's/\n/\n\n/g; s/ +/\n/g;' > eng.raw.conll)
			 
			(cat eng.card | \
			 perl -pe 's/^$/<br>/g; s/\n/ /g; s/<br>/\n/g; while(m/\([^\)]*\)/) { s/\([^\)]*\)/ /g }; s/   */ /g;' | \
			 perl -pe 's/\n/\n\n/g; s/ +/\n/g;' > eng.card.conll)
			 
			# undo functional replacements
			$CONLL_MERGE eng.card.conll eng.psd.conllu 0 1 -lev > eng.conllu.tmp; 
			paste <(cut -f 2 eng.conllu.tmp) <(cut -f 1,3- eng.conllu.tmp) > eng.conllu.card.tmp	# restore column order

			$CONLL_MERGE eng.raw.conll eng.conllu.card.tmp 0 1 -lev > eng.conllu.tmp
			paste <(cut -f 2 eng.conllu.tmp) <(cut -f 1,3- eng.conllu.tmp) > eng.conllu				# restore column order
			

		fi
		
		#############
		# ALIGNMENT #
		#############
				
		# alignment
		echo -n "alignment .. " 1>&2
		if [ -s sux_eng.snt ]; then
			echo "skipped (found sux_eng.snt)" 1>&2
		else
			$PLAIN2SNT_OUT sux eng
			$MKCLS -psux -Vsux.vcb.classes
			$MKCLS -peng -Veng.vcb.classes
			$GIZA -S sux.vcb -T eng.vcb -C sux_eng.snt
			if [ -s sux_eng.snt ]; then
				echo ok 1>&2
			else
				echo failed 1>&2	# must not be empty
			fi;
		fi;

		# create a TSV ("CoNLL") file for the alignment
		echo -n "giza2conll .. " 1>&2
		if [ -s eng_sux.conll ]; then
			echo "skipped (found eng_sux.conll)" 1>&2
		else
			# the *most recent* A3
			A3=`ls -t *A3.final | head -n 1`;
			cat $A3 | $PYTHON giza2conll.py > eng_sux.conll
			if [ -s eng_sux.conll ]; then
				echo ok 1>&2;
			else 
				echo failed 1>&2	# must not be empty
			fi;
		fi;

		echo -n "aggegate segments to documents .. " 1>&2
		if [ -s eng_sux.mrg.conll ]; then
			echo "skipped (found eng_sux.mrg.conll)" 1>&2
		else
			# normalize via English
			# (a) eng: one document per line
			less eng | perl -pe 's/(.) *\n/$1 /g;' | \
			sed -e s/'   *'/' '/g \
				-e s/' $'//g \
				-e s/'^ '//g \
				-e s/'$'/'\n'/g \
				-e s/' '/'\n'/g > eng-norm.conll

			# (b) enforce that segmentation to alignment
			$CONLL_MERGE eng-norm.conll eng_sux.conll 0 2 -lev | \
			grep -v -a '#' > eng_sux.mrg.conll
			if [ -s eng_sux.mrg.conll ]; then
				echo ok 1>&2
				rm eng-norm.conll
			else
				echo failed 1>&2 # must not be empty
			fi
		fi;

		###########
		# MERGING #
		###########

		# not stable, just run sequentially
		# # wait for parsing to finish and report in case of errors
		# echo -n "parsing .. " 1>&2 &
		# wait
		# if [ -s eng.conllu ]; then
			# echo ok 1>&2
		# else
			# ls -l eng.conllu 1>&2
			# echo failed 1>&2	# must not be empty
			# cat eng.conllu.log 1>&2	# error log from parsing
			# echo 1>&2
		# fi;
		
		# merge with dependency annotation
		echo -n "merging .. " 1>&2
		if [ -s eng_sux.mrg.conllu ]; then
			echo "skipped (found eng_sux.mrg.conllu)" 1>&2
		else 
			$CONLL_MERGE eng_sux.mrg.conll eng.conllu 0 1 -lev > eng_sux.mrg.conllu
			if [ -s eng_sux.mrg.conllu ]; then
				echo ok 1>&2
			else
				echo failed 1>&2
			fi;
		fi;

		# reorder within each document to restore Sumerian order
		echo -n "restore Sumerian word order .. " 1>&2
		if [ -s eng_sux.ordered.conllu ]; then
			echo "skipped (found eng_sux.ordered.conllu)" 1>&2
		else
			cat eng_sux.mrg.conllu | iconv -f utf-8 -t utf-8 -c | \
			$PYTHON reorder-sentences.py 1 3 2 > eng_sux.ordered.conllu
			if [ -s eng_sux.ordered.conllu ]; then
				echo ok 1>&2
			else
				echo failed 1>&2
			fi;
		fi

		# restore un-normalized Sumerian text
		echo -n "undo normalization .. " 1>&2
		if [ -s sux_eng.conllu ] ; then
			echo "skipped (found sux_eng.conllu)" 1>&2
		else
			if [ ! -e sux.raw.conll ]; then
				# align with raw sumerian (only readability marks removed)
				sed -e s/'\t'/' '/g \
					-e s/'[#]'//g \
					-e s/'\['//g \
					-e s/'\]'//g \
					-e s/'\?'//g sux.raw | \
				perl -pe 's/\s+/\n/g;' > sux.raw.conll	
			fi;

			# resulting file, with values for card, etc., restored
			$CONLL_MERGE sux.raw.conll eng_sux.ordered.conllu 0 4 -lev -drop none  > sux_eng.conllu
			
			if [ -s sux_eng.conllu ] ; then
				# transform document IDs into comments
				sed -i s/'^\([^\t]*\/P[^\t]*\.atf\).*$'/'# \1'/g sux_eng.conllu		
				echo ok 1>&2;
				rm sux.raw.conll
			else
				echo failed 1>&2
			fi;
		fi;
		
		#########
		# SPLIT #
		#########
		
		echo -n 'splitting .. ' 1>&2;
		if find sux_eng/ 2>/dev/null| grep 'conll$' | wc -l | egrep '^[1-9][0-9]*$' >& /dev/null; then 
			echo -n "skipped: found " 1>&2; 
			find sux_eng/ | grep 'conll$' | wc -l 1>&2
		else
			mkdir sux_eng >&/dev/null
			cd sux_eng
			cat ../sux_eng.conllu | \
			$PYTHON ../split-atf-conll.py
			cd ..
			echo -n "ok: " 1>&2
			find sux_eng/ | grep 'conll$' | wc -l 1>&2	# report number of files 
		fi;
		
		###############
		# CONSOLIDATE #
		###############
		# reduce to annotations for Sumerian
		
		echo "projection .. " 1>&2
		for file in `find sux_eng/ | grep 'conll$' | sed s/'\/[^\/]*$'// | uniq | sort -u`; do
			file=`echo $file | sed s/'sux_eng'/'sux_projected'/`
			if [ ! -e $file ]; then
				mkdir -p $file >& /dev/null;
			fi;
		done
		for file in `find sux_eng/ | grep 'conll$'`; do
			tgt=`echo $file | sed s/'sux_eng'/'sux_projected'/`;
			echo -n "  "$tgt" " 1>&2;
			if [ -e $tgt ]; then echo found 1>&2	# not -s, to parallelize
			else
				(cat $file | \
				# no parallelization
				$LOAD WORD ENG LINE ENG_GIZA SUX_GIZA SUX_NORM ENG_ID ENG_NORM ENG_LEMMA POS FEATS ENG_HEAD EDGE DEPS MISC \
					-u get-cdli-conll.sparql perform-deletions.sparql | \
				$WRITE -conll ID WORD GLOSS POS NEW_HEAD EDGE | \
				egrep -v '# tr.en.*atf$' | \
				egrep -v '# global.columns' > $tgt
				) 2> $tgt.log
				if [ -s $tgt ]; then echo ok 1>&2
				else echo failed 1>&2;
					cat $tgt.log 1>&2;
					echo 1>&2
				fi;
			fi;
		done;
		echo -n "projection: " 1>&2
		find sux_projected/ | grep 'conll$' | wc -l 1>&2	# report number of files 
		
		## en bloc (out of mem, but much faster)
		# if [ -s sux.projected.conll ]; then
			# echo "skipped (found sux.projected.conll)" 1>&2;
		# else 
			# cat sux_eng.conllu | \
			# $LOAD WORD	ENG	LINE	ENG_GIZA	SUX_GIZA	SUX_NORM	ENG_ID 	ENG_NORM	ENG_LEMMA POS	FEATS 	ENG_HEAD	EDGE	DEPS	MISC | \
			# $UPDATE get-cdli-conll.sparql perform-deletions.sparql | \
			# $WRITE -conll ID WORD GLOSS POS NEW_HEAD EDGE | \
			# egrep -v '# tr.en.*atf$' | \
			# egrep -v '# global.columns' > sux.projected.conll
			# if [ -s sux.projected.conll ] ; then
				# echo ok 1>&2
			# else echo failed 1>&2;
			# fi;
		# fi;
		
		# sux_cdli: mapping to CDLI schema
	fi;
fi;
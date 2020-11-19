#!/bin/bash
# take a text in two annotations and merge it

#########
# input #
#########

CDLI_CONLL=../cdli/conll/;
ETCSRI_CONLL=../etcsri/cdli-conll/;
PROJ_CONLL=../parallel/sux_projected/;

if echo $3 | egrep . >&/dev/null; then
	CDLI_CONLL=$1
	ETCSRI_CONLL=$2
	PROJ_CONLL=$3
fi;

if [ ! -d $CDLI_CONLL ]; then CDLI_CONLL=../cdli/conll/; fi
if [ ! -d $ETCSRI_CONLL ]; then ETCSRI_CONLL=../etcsri/cdli-conll/; fi
if [ ! -d $PROJ_CONLL ]; then PROJ_CONLL=../parallel/sux_projected/; fi

echo running $0 $CDLI_CONLL $ETCSRI_CONLL $PROJ_CONLL 1>&2

##########
# output #
##########

MRG=raw
if [ ! -d $MRG ]; then mkdir -p $MRG; fi

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

for file in $ETCSRI_CONLL/*; do
	et=$file
	file=`basename $file`
	echo processing $file  1>&2
	if [ ! -e $CDLI_CONLL/$file ]; then
		echo warning: $CDLI_CONLL/$file not found, skipping 1>&2
	else
		cd=$CDLI_CONLL/$file
		pr=$PROJ_CONLL/$file
		if [ ! -e $pr ]; then
			echo -n "[warning: no "$pr" => " $cd"] " 1>&2
			pr=$cd
		fi;

		#########
		# merge #
		#########

		mrg=$MRG/$file
		echo -n merge $cd "+" $et " + " $pr "=>" $mrg" " 1>&2;
		if [ -s $mrg ]; then
			echo skipped "(output file found)" 1>&2
		else
			# relics
			# (cat $cd | $LOAD ID WORD GLOSS POS HEAD EDGE | $WRITE -grammar > $cd.txt) >&/dev/null &
			# (cat $TRANSACTION| $LOAD ID WORD _ _ _ _ HEAD EDGE | $WRITE -grammar > $TRANSACTION.txt) >& /dev/null &
			# (if [ -e $ENGLISH ]; then 
				# cat $ENGLISH | $LOAD ID WORD GLOSS _ POS _ HEAD EDGE | $WRITE -grammar > $ENGLISH.txt;
			# fi) >& /dev/null &
			
	
			# # works, but we need ETSCRI both in aggregated (-f) and non-aggregated (-lev) form
			# $MERGE $cd $et $pr 1 1 -drop none -lev > $mrg
			
			 $MERGE $cd $et 1 1 -f -drop none | \
			 $MERGE -- $et 1 1 -lev -drop none | \
			 $MERGE -- $pr 1 1 -lev | egrep '^[^#]*$|tr.en:' > $mrg

			# wait %1 %2	# only for the first two
			# paste $TRANSACTION.txt $PROJECTION.txt > $MERGED.txt

			if [ -s $mrg ]; then
				echo ok 1>&2;
			else
				echo failed 1>&2;
			fi;
		fi;

		# #############
		# # integrate #
		# #############

		# cat $MERGED | \
		# $LOAD ID WORD _ _ _ _ HEAD EDGE _ PSD _ GLOSS POS HEAD2 EDGE2 | \
		# $TRANSFORM -updates consolidate.sparql | \
		# $WRITE -conll ID WORD GLOSS POS HEAD EDGE DEPS MISC > $OUTPUT

		# cat $OUTPUT | \
		# $LOAD ID WORD GLOSS POS HEAD EDGE DEPS MISC | \
		# $WRITE -grammar > $OUTPUT.txt

		# #########
		# # close #
		# #########

		# wait # for English grammar
		
	fi;
done;
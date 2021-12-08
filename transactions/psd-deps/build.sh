#!/bin/bash
# transaction parsing of all *.conll files under ../comm_conll, replicates original directory structure
# remove subdirectories to refresh

########
# CONF #
########

PYTHON=python3
SRC=../psd

# set to your CoNLL-RDF home or get it from https://github.com/acoli-repo/conll-rdf
CONLL=~/conll-rdf

########
# PREP #
########

if [ ! -e cfg-parser/ ]; then
	git clone https://github.com/cdli-gh/cfg-parser.git
else
	cd cfg-parser;
	git pull;
	cd ..
fi

#LOAD=$CONLL/run.sh" CoNLLStreamExtractor http://ignore.me/ WORD PARSE"
LOAD=$CONLL/run.sh" CoNLLBrackets2RDF '#'"
TRANSFORM=$CONLL/run.sh" CoNLLRDFUpdater -custom -updates"
WRITE=$CONLL/run.sh" CoNLLRDFFormatter "

##########
# UPDATE #
##########

FILES=`cd $SRC >&/dev/null; find | grep 'conll$'` #  | head -n 38 | tail -n 20`

for file in $FILES; do
	dir=`dirname $file`;
	if [ ! -d $dir ]; then mkdir -p $dir ; fi
	echo -n $file' ' 1>&2
	src=../psd/$file
	src=`readlink -f $src;`
	tgt=`readlink -f $file;`
	if [ -e $tgt ]; then
		echo found, keeping it 1>&2
	else
		# cat $src | egrep -n '^';
		cat $src | \
 	  $LOAD WORD SEG POS MORPH _ _ PARSE 2>/dev/null | \
		perl -pe '
			s/[|][^\t\n]*"/"/g;
			s/(#[^\t\n]*)[|{}][^\t\n]*>/$1>/g;
		' | \
		$TRANSFORM \
        cfg-parser/consolidate-parse.sparql \
        cfg-parser/parse2psd.sparql \
        cfg-parser/parse2dep.sparql \
        cfg-parser/dep2ud.sparql \
				2>/dev/null | \
			$WRITE -conll ID WORD SEGM POS MORPH HEAD EDGE MISC | \
			perl -pe '
				s/[|][^\t\n]*/ /g;
			' > $tgt
			if [ -s $tgt ]; then
				echo ok 1>&2;
			else
				echo failed 1>&2
				echo 1>&2
			fi;
	fi;
done;

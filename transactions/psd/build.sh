#!/bin/bash
# transaction parsing of all *.conll files under ../comm_conll, replicates original directory structure
# remove subdirectories to refresh

########
# CONF #
########

# set to transaction parser home or get it from https://github.com/cdli-gh/cfg-parser
PARSE_DIR=~/cdli-gh/cfg-parser

PYTHON=python3

SRC=../comm_conll

##########
# UPDATE #
##########

FILES=`cd $SRC >&/dev/null; find | grep 'conll$'` # | head -n 1`

#for file in P100/*001.conll; do 
#for file in */*.conll; do
for file in $FILES; do
	dir=`dirname $file`;
	if [ ! -d $dir ]; then mkdir -p $dir ; fi
	echo -n $file' ' 1>&2
	src=../comm_conll/$file
	src=`readlink -f $src;`
	tgt=`readlink -f $file;`
	if [ -e $tgt ]; then
		echo found, keeping it 1>&2
	else
		cd $PARSE_DIR
		$PYTHON parse_comm.py $src > $tgt
		cd - >&/dev/null
		if [ -s $tgt ]; then
			echo ok 1>&2;
		else
			echo failed 1>&2
			echo 1>&2
		fi;
	fi;
done;

#!/bin/bash
# PRE: eng/ directory with atf-based English translations (*.txt) or ETCSRI-based English translations (*.etcsri.txt, only if no ATF-based translation)
# PRE: ../cdli/atf/ directory with CDLI atfs

# POST: for every eng file, create a Sumerian txt file from the atf
#       and run ./align.sh over it

#########################
# create sux/ directory #
#########################
if [ ! -e sux ]; then
	mkdir sux;
fi;

for file in eng/*; do
	base=`basename $file | sed s/'_.*'//`;
	atf=`ls ../cdli/atf/$base*atf | grep -m 1 .`;
	tgt=sux/`basename $file | sed s/'\..*'//g`.txt
	echo -n $tgt' ' 1>&2;
	if [ -s $tgt ]; then
		echo found 1>&2;
	else
		if [ -e $atf ]; then
			egrep '^[a-z]?[0-9][0-9a-z\-]*[^0-9a-zA-Z\.\s]*\s*\.\s*' $atf | \
			perl -pe 's/^[a-z]?[0-9][0-9a-z\-]*[^0-9a-zA-Z\.\s]*\s*\.\s*//;' > $tgt
			if [ -s $tgt ]; then
				echo ok 1>&2
			else
				echo failed 1>&2
			fi;
		else
			echo failed' ('$atf' not found)' 1>&2
		fi;
	fi;
done;

###############################################
# one document per line for files from ETCSRI #
###############################################
# ETCSRI translations are paragraph-aligned only, but we don't have the corresponding breaks in the CDLI-ATF.
# We thus treat the entire document as a single sentence.
# GIZA++ does have a sentence length limit of 100 words. No Ur III ETSCRI document (among those without
# translations in the ATF) exceeds that. (But note that this won't work for ETSCRI as a whole.)
# CDLI ATFs are aligned for every line.

for file in eng/*etcsri*txt; do
	base=`basename $file | sed s/'_.*'//`;
	sux=sux/`basename $file | sed s/'\..*'//g`.txt
	sux_cdli=sux/`basename $file | sed s/'\..*'//g`.cdli.txt
	tgt=eng/`basename $sux`;
	echo -n $tgt' ' 1>&2;
	if [ -s $tgt ]; then
		echo found 1>&2;
	else
		(cat $file | \
		perl -pe 's/^\(([a-zA-Z]+\s*)?[0-9]+[^a-zA-Z0-9\s]*\s*\)\s+//g; s/\s+/ /g;' | \
		perl -pe 's/  +/ /g;'
		echo) > $tgt
		if [ -s $tgt ]; then
			echo ok 1>&2;
		else 
			echo failed 1>&2;
		fi;
	fi;
	echo -n normalize $sux' ' 1>&2;
	if [ -e $sux_cdli ]; then
		echo skipped 1>&2;
	else
		mv $sux $sux_cdli
		(cat $sux_cdli | \
		perl -pe 's/\s+/ /g;' | \
		perl -pe 's/  +/ /g;';
		echo) > $sux
		if [ -s $sux ]; then
			echo ok 1>&2;
		else
			echo failed 1>&2;
		fi;
	fi;
done;

######################
# validate alignment #
######################

for sux in sux/*; do
	eng=eng/`basename $sux`;
	sux_cdli=sux/`basename $sux | sed s/'\..*'//g`.cdli.txt
	if [ -s $eng ]; then
		if [ `cat $sux | wc -l` = `cat $eng | wc -l` ]; then 
			echo $sux $eng valid >&/dev/null; #1>&2;
		else
			echo warning: $sux `cat $sux | wc -l` '('`cat $sux | wc -w`')' but $eng `cat $eng | wc -l` '('`cat $eng | wc -w`')' 1>&2;
			if [ ! -e sux/tmp ]; then
				mkdir sux/tmp
			fi;
			mv $sux sux/tmp
			mv $eng sux/tmp
			if [ -e $sux_cdli ]; then
				mv $sux_cdli sux/tmp
			fi;
		fi;
	fi;
done;

#####################
# normalize english #
#####################

for eng in eng/*; do
	# fix extraction artifacts from CDLI-ATF
	sed -i s/'^: '//g $eng
done;

#####################
# align and project #
#####################

./align.sh -clean sux/ eng/
#!/bin/bash
# for every eng file, create a Sumerian txt file from the atf

if [ ! -e sux ]; then
	mkdir sux;
fi;

for file in eng/*; do
	base=`basename $file | sed s/'_.*'//`;
	atf=`ls ../atf/$basename*atf | grep -m 1 .`;
	tgt=sux/`basename $file | sed s/'\..*'//g`.txt
	echo -n $tgt' ' 1>&2;
	if [ -s $tgt ]; then
		echo found 1>&2;
	else
		if [ -e $atf ]; then
			egrep '^[1-9][0-9]*\s*\.\s*' $atf | \
			perl -pe 's/^[0-9]+\s*\.\s*//;' > $tgt
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


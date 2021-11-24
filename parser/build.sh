#!/bin/bash
rm *.conllu
for dir in ../royal/release/data/ ../parallel/consolidated/; do
	for file in `find $dir | grep 'conll$'`; do
		name=`basename $file`
		group=`echo $name | sed -e s/'[^0-9]'//g -e s/'.*\(.\)$'/'\1'/g;`
		if [ $group = "5" ]; then 
			group=test;
		elif [ $group  = "7" ]; then
			group=dev;
		else
			group=train;
		fi;
		echo $file ">" $group.conllu 1>&2;
		cat $file | python3 cdli2conllu.py >> $group.conllu;
		echo  >> $group.conllu;
	done;
done


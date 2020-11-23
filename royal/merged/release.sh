#!/bin/bash
# export consolidated annotations to ../release

if [ ! -d ../release ] ; 	 then mkdir ../release; 		fi;
if [ ! -d ../release/data ]; then mkdir ../release/data; 	fi;

for file in consolidated/P[0-9]*; do 
	tgt=../release/data/`basename $file | sed -e s/'.*\/'//g -e s/'_Q.*'//`.conll; 
	echo -n $file ">" $tgt" " 1>&2
	if [ -s $tgt ]; then
		echo skipped, $tgt found 1>&2
	else
		(echo "# global.columns = ID WORD SEGM POS MORPH HEAD EDGE MISC"
		 egrep -m 1 '# tr.en' $file;
		 egrep '^[0-9]' $file | cut -f 1-7 | sed s/'$'/'\t_'/
		 echo) > $tgt
		if [ -s $tgt ]; then
			echo ok 1>&2;
		else
			echo failed 1>&2
		fi;
	fi;
done

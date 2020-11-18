# read a CoNLL file created from a series of txt files
# assume that every line that matches "^# .*txt" indicates the location of a file to *append* to
# if the file includes a path, we create the necessary directories
# note that this is always interpreted as a *relative* path
import sys
import os
import re

pathout = "header.conllu"
file = None
for line in sys.stdin:
	line=line.rstrip()
	if(re.match("^# .*txt$",line)):
		if(file):
			file.write("\n")
			file.close()
			file=None
		pathout=re.sub("^#\s*","",line);
		if(".txt" in pathout):
			try:
				os.makedirs(re.sub(r"\/[^\/]*$","",pathout))
			except FileExistsError:
				pass
		file=open(re.sub(r"\.txt$","",pathout)+".conll","w");
	if(file == None):
		if(len(line)>0):
			sys.stderr.write("warning: no file initialized when trying to write line \""+line+"\"")
	else:
		file.write(line+"\n")
file.close()
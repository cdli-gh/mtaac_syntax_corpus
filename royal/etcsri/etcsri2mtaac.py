import os
import sys
import re

from mtaac_package.morph_annotation import *
from mtaac_package.ATF_transliteration_parser import transliteration, sylb
from mtaac_package.common_functions import *
		
import argparse
args=argparse.ArgumentParser(description="convert ETCSRI corpus to CDLI/MTAAC conventions")
args.add_argument("input", metavar="N", type=str, help="input directory, containing ETCSRI CoNLL files")
args.add_argument("output", metavar="N", type=str, help="output directory, we do not overwrite")
args=args.parse_args()

# replace single-character shorthands by conventional CDLI transliterations 
def fix_translit(string):
	fix={}
	fix["c"]="sz"
	fix["C"]="Sz"	# shouldn't happen
	fix["j"]="g"
	fix["J"]="G"	# shouldn't happen
	for f in fix: 
		while f in string:
			string=re.sub(f,fix[f],string)
	return string	

# minor simplifications to match the MTAAC scheme
def fix_pos(string):
	fix={}
	fix["V/i"]="V"
	fix["V/t"]="V"
	for f in fix: 
		while f in string:
			string=re.sub(f,fix[f],string)
	return string	

# replace STEM and NAME by POS
def fix_xpos(morph,pos):
	pos=fix_pos(pos)
	for placeholder in [ "STEM", "NAME" ]:
		if placeholder in morph:
			morph=re.sub(placeholder,pos,morph)
	return morph
	
# minor simplifications of the original ETSCRI dependencies (only if attested)
def fix_dep(dep):
	fix={}
	fix["DAT-H"]="DAT"
	fix["DAT-NH"]="DAT"
	fix["L1"]="LOC"
	fix["L2-NH"]="LOC"
	fix["L3-NH"]="LOC"
	for f in fix: 
		while f in dep:
			dep=re.sub(f,fix[f],dep)
	return dep	
	
mc=morph_converter()

sys.stderr.write("processing\n")

if not os.path.isdir(args.output):
	os.makedirs(args.output)

for file in os.listdir(args.input):
	if os.path.isfile(args.input+"/"+file):
		sys.stderr.write("\t"+args.input+"/"+file+" ")
		if os.path.isfile(args.output+"/"+file):
			sys.stderr.write("skipped, found "+args.output+"/"+file+"\n")
		else:
			# conll_file is largely broken, we do it by hand
			# result=conll_file(path=args.input+"/"+file)
			
			with open(args.input+"/"+file,"r") as input:
				with open(args.output+"/"+file,"w") as output:
					for line in input:
						if(line.startswith("#")):
							output.write(line)
						else:
							if(re.search(r"[^\\]#",line)):
								output.write(re.sub(r"([^\\])(#[^\n]*)",r"\2\n",line))
								line=re.sub(r"([^\\])#[^\n]*",r"\1",line)
							line=line.rstrip()
							fields=line.split("\t")
							if(len(fields)<8):
								output.write(line+"\n")	# no valid input
							else:
								id=fields[0]
								word=fields[1]
								base=fields[2]
								morph2=fields[3]
								head=fields[4]
								edge=fields[5]
								pos=fields[6]
								gloss=fields[7]
								comment="_"
								
								xpos=fix_xpos(mc.ORACC2MTAAC(morph2, pos),pos)
								pos=fix_pos(pos)
								try:
									word = fix_translit(transliteration(word).base_translit)
								except AttributeError:
									sys.stderr.write("\nwarning: translitation error in \""+word+"\" ")
									pass

								segm=None
								try:
									segm=fix_translit(transliteration(base).base_translit)+"["+re.sub(r"\s+",".",gloss)+"]"
								except AttributeError:
									sys.stderr.write("\nwarning: translitation error in \""+base+"\" ")
									segm=fix_translit(base)+"["+re.sub(r"\s+",".",gloss)+"]"

								edge=fix_dep(edge)
								
								#print(line)
								output.write(id+"\t"+word+"\t"+segm+"\t"+pos+"\t"+xpos+"\t"+head+"\t"+edge+"\t_\n")

								# note that we do lose the morphemes in segm because these are lost in the parse, already
				sys.stderr.write("done\n")
		sys.stderr.flush()
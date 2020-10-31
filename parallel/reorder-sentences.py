# python 3.7
import sys
import re
import argparse

parser=argparse.ArgumentParser(description='sort rows within empty-line separated sentences according to the numerical values of the defined columns')
parser.add_argument('cols', metavar='N', type=int, nargs='+',
                    help='columns for sort within sentence (numerical sort), starting with 0')

args = parser.parse_args()

#
# methods
#

def print_sentences(sentences, cols):
	#print(sentences)
	while(len(sentences)>0):
		line=0
		for cand in range(len(sentences)):
			for col in cols:
				if(len(sentences[cand])>col):
					if(len(sentences[line])<=col):
						line=cand
					if(not str.isnumeric(sentences[cand][col])):
						cand=line
					elif(not str.isnumeric(sentences[line][col])):
						line=cand
					elif(float(sentences[cand][col])<float(sentences[line][col])):
						line=cand
					elif(float(sentences[cand][col])>float(sentences[line][col])):
						cand=line						
		for f in sentences[line]:
			print(f.strip(),end="\t")
		print()
		sentences.pop(line)
	
# reads from stdin
# within every empty-line separated block
# sort numerically according to the sequence of columns defined as argument

# print comments directly
# store sentences as list of values
sentences=[]
for line in sys.stdin:
	if(line.startswith("#")):	# comment
		print(line.rstrip())
	elif(len(line.strip())==0): # empty line
		print_sentences(sentences,args.cols)
		sentences.clear()
		print()
	else:
		sentences.append(line.split("\t"))
		
print_sentences(sentences,args.cols)
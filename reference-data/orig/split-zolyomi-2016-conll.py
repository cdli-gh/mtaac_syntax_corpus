import sys,re,os

header=[]

file=None
with open('Pxxxxxx.zolyomi-2016.conll',"rt") as input:
	for line in input:
		line=line.strip()
		if len(line)>0 and re.match(r"^#\s*[PQ][0-9][0-9][0-9][0-9][0-9][0-9]$",line.strip()):
				if not isinstance(header,str):
					header="\n".join(header)+"\n"
				file=re.sub(r"[^PQ0-9]","",line)
				file=file+"_fragments.zolyomi-2016.conll"
				if not os.path.exists(file):
					with open(file,"wt") as output:
						output.write(line+"\n\n"+header+"\n")
		if file!=None:
			with open(file,"at") as output:
				output.write(line+"\n")
		elif not isinstance(header,str):
				header.append(line)

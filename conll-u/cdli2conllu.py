import re,os,sys

pos2upos= {
	"_" :"X",
	"AJ": "ADJ",
	"AV": "ADV",
	"CC": "CCONJ",
	"CNJ": "CCONJ",
	"DET": "DET", 
	"DN" : "PROPN",
	"EN" : "PROPN",
	"FN" : "PROPN",
	"GN" : "PROPN",
	"IP" : "X",
	"L" : "X",
	"MN" : "PROPN",
	"n" : "NOUN",
	"N" : "NOUN",
	"N|N" :"NOUN",
	"NU" : "NUM",
	"ON" :"PROPN",
	"PN" :"PROPN",
	"PN|PN" :"PROPN",
	"RN": "PROPN",
	"SN" :"PROPN",
	"TN" :"PROPN",
	"u" :"X",
	"V" :"VERB",
	"V|V" :"VERB",
	"WN" :"PROPN",
	"X" : "X" }
dep2udep={
	"appos": "appos",
	"nummod": "nummod",
	"acl": "acl",
	"GEN": "nmod",
	"nmod": "nmod",
	"ABS": "obj",
	"root": "root",
	"dep": "dep",
	"LOC": "obl",
	"ABL": "obl",
	"DAT": "iobj",
	"amod": "amod",
	"parataxis": "parataxis",
	"ERG": "nsubj",
	"via": "obl",
	"TERM": "obl",
	"COM": "nmod",
	"date": "obl",
	"acl.ADV": "advcl",
	"mwe": "flat",
	"conj": "conj",
	"cc": "cc",
	"EQU": "nmod",
	"GEN.TERM": "obl",
	"nmod:per": "obl",
	"GEN.GEN": "nmod",
	"ADV": "advmod",
	"GEN.ERG": "nsubj",
	"dep|dep": "dep",
	"x": "dep",
	"nmod|nmod": "nmod",
	"nmod:accord": "obl",
	"GEN.ABS": "obj",
	"nsubj": "nsubj",
	"nmod:without": "nmod",
	"nmod:give": "nmod",
	"appos|appos": "appos" }
for line in sys.stdin:
	line=line.strip()
	if line.startswith("#") or len(line)==0:
		print(line)
	else:
		fields=line.split("\t")
		id=fields[0]
		word=fields[1]
		seg=fields[2]
		pos=fields[3]
		morph=fields[4]
		head=fields[5]
		edge=fields[6]
		misc=fields[7]
		upos="X"
		if pos in pos2upos:
			upos=pos2upos[pos]
		dep="dep"
		if edge in dep2udep:
			dep=dep2udep[edge]
		print("\t".join([id,word,"_",upos,pos,"_",head,dep,"_","_"]))

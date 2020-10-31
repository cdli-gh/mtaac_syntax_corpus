# python 3.7
import sys
import re

# read *.A3.final file as produced by Giza
# (not to be confused with the *a3.final file; note that under Windows, the *a3.final file may have overwritten the *A3.final file)
# comments (starting with #) are not processed, but copied into the output
# we expect the first content line to be English (plain sentence), the second to be Sumerian (with alignment with English, starting with "NULL ({")

sentence=1
english=""
for line in sys.stdin:
	line=line.rstrip()
	if(line.startswith("#")):
		print(line)
	elif(line.startswith("NULL ({")):
		sumerian=line
		sux=re.sub(r"\s*\(\{[^\}\)]*\}\)\s*"," ",sumerian)[5:].rstrip()
		
		print("# eng:",english)
		print("# sux:",sux)
		eng=english.split(" ")
		sux=sux.split(" ")
		print("# alignment:", sumerian)
		sux2eng=list(map(lambda x: re.sub(r".*\(\{ ([^\}\)]*)( \}\))?$",r"\1",x).strip(), sumerian.split("}) ")))[1:]
		eng2sux=list(map(lambda e: [], eng))
		for nr,es in enumerate(sux2eng):
			id=nr+1
			for e in es.split():
				try:
					enr=int(e)-1
					eng2sux[enr].append(id)
				except:
					pass
		#print("eng2sux:",eng2sux)
		print("# SENT\tID_ENG\tENG\tID_SUX\tSUX")
		
		suxPrinted=set([])
		for nr,e in enumerate(eng):
			id=str(nr+1)
			if(len(eng2sux[nr])==0):
				print(str(sentence)+"\t"+id+"\t"+e+"\t_\t_")
			else:
				for sid in eng2sux[nr]:
					snr=int(sid)-1
					if snr in suxPrinted:
						print(str(sentence)+"\t"+id+"\t"+e+"\t"+str(sid)+"\t_")
					else:
						print(str(sentence)+"\t"+id+"\t"+e+"\t"+str(sid)+"\t"+sux[snr])
					suxPrinted.add(snr)
		for snr,s in enumerate(sux):
			sid=str(snr+1)
			if not snr in suxPrinted:
				print(str(sentence)+"\t_\t_\t"+sid+"\t"+s)
		sentence=sentence+1
		english=""
		sumerian=""
		print()
	else:
		english=line

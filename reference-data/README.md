# Reference data

Manually analyzed sample data, mostly drawn from the literature

- [orig](orig) spreadsheets or other source files containing the original annotation, their interpretation in terms of MTAAC guidelines and a mapping to UD v.2 in different tabs
- [conll](conll) static export of original annotations in a TSV format. Note that this schema overlaps partially with UD v.2 specifications. Note that a conversion to UD v.2 is possible, but not reversible (not lossless). Note that dependencies are CDLI-compliant, but (a) these are not updated anymore, and (b) they original transliteration (and word-level annotations)
- [cdli-conll](cdli-conll) CoNLL dependencies aligned with CDLI tokens

## known issues
- at the moment, FORM/WORD, SEGM/LEMMA, XPOS columns follow (mostly) the original source, not MTAAC/CDLI
- this also includes transcription rules in FORM/WORD
- Jagersma not complete yet (currently in `orig/` only, but not exported, yet)

As the data comes from different sources, the morphological analyses are not fully consistent. PPCS systematically uses `DAT` for Zolyomi's `L3.NH`. This has not been fixed in the analyses.

	# A 17:17 (PPCS)
	1	e2-a	e2	house(hold)	5	GEN+disloc	_	_
	2	{d}en-ki-ke4	en-ki	Enki	5	ERG	_	_
	3	jic-hur-bi	jic-hur	design	5	DAT	_	_
	4	si	si	horn	5	ABS	_	_
	5	mu-na-sa2	sa2	to equal	0	root	_	_

	# Zolyomi (2016): (37) Gudea Cyl. A 17:17 (Lagash, 22nd c.) (ETCSL 2.1.7)
	#“Enki put right the design of the temple for him.”
	# complemented with PPCS-based lemmas
	1	e₂-a	e2[house(hold)]	temple=GEN	5	GEN+dislocated	_
	2	{d}en-ki-ke₄	en-ki	DN=ERG	5	ERG	_
	3	ŋiš-ḫur-be₂	ŋiš-ḫur[design]	plan=3.SG.NH.POSS=L3.NH	5	LOC	_
	4	si	si[horn]	horn=ABS	5	ABS	_
	5	mu-na-sa₂	sa2[to.equal]	VEN-3.SG.H-DAT-3.SG.H.A-equal-3.SG.P	0	root	_

Sometimes, also the character readings are different, with different morphological (and semantic) interpretations about case. If the same phrase is anapyzed in both Zolyomi and PPCS, we take the longer analysis as basis (also for transliteration). If PPCS and Zolyomi deviate, we follow Zolyomi.
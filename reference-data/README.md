# Reference data

Manually analyzed sample data, mostly drawn from the literature

[orig](orig) spreadsheets or other source files containing the original annotation, their interpretation in terms of MTAAC guidelines and a mapping to UD v.2 in different tabs
[cdli-conll](cdli-conll) static export of original annotations in a TSV format. Note that this schema overlaps partially with UD v.2 specifications
[conllu](conllu) static export of CDLI annotations into into UD v.2 specifications. Note that this conversion is not lossless.

known issues:
- at the moment, FORM/WORD, SEGM/LEMMA, XPOS columns follow (mostly) the original source, not MTAAC/CDLI
- this also includes transcription rules in FORM/WORD
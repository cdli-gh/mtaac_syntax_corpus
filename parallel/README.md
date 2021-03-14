# MTAAC/CDLI Ur-III parallel subcorpus

Projected dependency annotations from English translations

## Contents

- `atf/` parallel subcorpus of the MTAAC/CDLI Ur-III corpus
- `morph/` parallel subcorpus of the MTAAC/CDLI Ur-III corpus with automated annotations for POS and MORPH
- `sux-projected/` raw projection from English, CoNLL format
- `consolidated/` MTAAC dependencies automatically derived from projections [TODO]

## Approach
- extract ATF files with English translations from https://github.com/cdli-gh/mtaac_cdli_ur3_corpus (preserve test/train/dev split)
- `align.sh` => `sux_projected/`
	- alignment
		- normalize English and Sumerian for alignment (e.g., replace numbers by `CARD`, drop English punctuation, etc.)
		- [Giza++](http://www.statmt.org/moses/giza/GIZA++.html): alignment  (IBM-4 models, no symmetric closure)
		- transform aligned file into CoNLL format, using English word order 
	- parsing
		-  [Stanford Core NLP](https://stanfordnlp.github.io/CoreNLP/): parsing *original* English translation with slight adjustments (e.g., replace `...` and `x` [unreadable words] with `something`, and `n` [unreadable number] with `5`) => CoNLL file (roughly compliant to UD v.1) 
		- [CoNLL-Merge](https://github.com/acoli-repo/conll-merge): merge CoNLL file with normalized English
	- projection
		- [CoNLL-Merge](https://github.com/acoli-repo/conll-merge): merge CoNLL file English-Sumerian alignment
		- [CoNLL-Merge](https://github.com/acoli-repo/conll-merge): merge Sumerian-English CoNLL file with non-normalized Sumerian text
		- [CoNLL-RDF](https://github.com/acoli-repo/conll-rdf): transfer annotations from English to Sumerian, rule-based handling of alignment gaps, export CoNLL files
- `consolidate.sh` => `consolidated/`
	- [CoNLL-Merge](https://github.com/acoli-repo/conll-merge): merge projection with POS+MORPH annotations
	- [CoNLL-RDF](https://github.com/acoli-repo/conll-rdf): normalize projected POS/EDGEannotations according to MTAAC guidelines
	- [CoNLL-RDF](https://github.com/acoli-repo/conll-rdf): consolidate POS/MORPH and projected annotations into CDLI-CoNLL output, this includes overwriting some projected+normalized dependency labels (e.g., numerals => `nummod`, adnominal verbs => `acl`, `acl` without arguments => `amod`) and ensuring parses are projective

## Known issues
- English translations are automatically annotated (Stanford Core NLP; this has also been used to create the annotations of the English Web Treebank, the UD reference corpus for English). However, the parses are not necessarily correct, especially if a tables involves gaps or a translation preserves Sumerian expressions. In particular, measurements are systematically expressed as compounds.
- Alignment performed with GIZA++, unidirectional (to encourage 1:n mappings). GIZA++ is still considered SOTA (despite experimental results such as reported by https://www.aclweb.org/anthology/2020.acl-main.146.pdf), but for low-frequency words, statistics may be indistinctive, favouring alignments with adjacent high-frequency words, instead. Hence, hapaxes are frequently aligned with punctuation, prepositions or conjunctions. This is usually incorrect. Punctuation has thus been removed from the alignment, but other alignment errors remain.
- As there are no sentence boundaries in Sumerian (and our texts are usually short), we treat every tablet as a single sentence and feed it into the parser. We suppress sentence splitting of the parser, but this can lead to parsing errors. (We initially worked with the Stanford Core NLP sentence splitter, but this led to index clashes that had to be heuristically resolved: we kept the *closest* head, but this still came with a high error rate in the alignment.
- Normalization of projected dependencies is heuristic. In case of alignment errors, Sumerian labels and attachment may be incorrect. This has not been manually checked, but confirmed by the inspection of samples.
- We did not attempt to merge with transaction parses. This is beyond the scope of this sub-corpus. Instead, that should be conducted in the transaction subcorpus.

## Postcorrections
- `sux-projected/`: For obviously incorrect alignments, the dependency labels are deleted. This includes all `punct` relations.
- `sux-projected/`: `case` dependencies are replaced by `nmod:$ENG_NORM`, e.g., `nmod:of` as there are no adpositions in Sumerian. However, some nominals are translated by prepositions (e.g., `nmod:via` for giri3), these need to be reconstructed accordingly.
- `sux-projected/`: For all dependents that are aligned with an English cardinal number, the dependency label is changed to `nummod`. This is in line with CDLI specs.
- `sux-projected/`: `dep` dependencies are deleted (no label, dependency untouched), unreadable words are labelled as `dep`
- `consolidated/`: POS `NU` => `nummod`, adnominal `V` => `acl`, `acl` without arguments => `amod`, postnominal `nmod` => `appos`
- `consolidated/`: projectivity fixes (attachment corrections may be incorrect)

## Mapping to MTAAC specifications (`consolidated/`)

Note that only a heuristic mapping is possible here. Labels are chosen to reflect the *most frequent* correspondence in Sumerian syntax, may be incorrect for a minority of cases and must be manually checked. Typical examples include the handling of case labels that are induced from their English translation. In other cases, the projected parses may inform the adjustment of the MTAAC annotation guidelines, e.g., for the handling of linguistically opaque expressions in Sumerian (e.g., *giri3*).

Mapping of case (against partial parse)

    367 nmod:of	=> GEN
    130 nmod:from	=> ABL (either ki X(-ta) or X(-ta)), with -ta ABL; cf. nmod:with below
    130 nmod:for	=> TERM; mostly unmarked, but -sze3 (14) [for TERM]
					BUT: some could be DAT (-ra) rather than TERM
					BUT also includes a-ra2
     51 nmod:npmod	(bare nominal modifiers *of predicates* lacking a preposition)
					almost always (49/53) gin2 "shekels" => nmod:unit
     33 nmod:to	=> TERM (-sze3, 12/42)
     29 nmod:in	=> LOC sza3 (6/33), following sza3 (9/33), ...a (L1, 10/33) 
     28 nmod:via	=> via (giri3, 12/39), following giri3 (16/39)
     22 nmod:under	=> kiszib3 (22/25) + after kiszib3 (1/25), translated as "under seal of"
     22 nmod:tmod	=> only for dates, keep as tmod (TODO: rename CDLI "date" to "tmod")
     20 nmod:poss	=> (indeed, these are almost all possessives) POSS.ABS 15/37, POSS.DAT-H 1/37 (but there are unnoticed possessives)
     10 nmod:by	=>	inim X-ta ("by order of") 2/11 or -e (LH-NH 2/11 -- only in year name); could also be ERG, but no such analysis for any known form in the gold corpus (0/11)
      7 nmod:with	=> ki+PN (4/7), all PN unmarked, but apparently GEN.ABL, cf. ki ab-ba-sa6-ga (P106228, parallel corpus), but ki ab-ba-sa6-ga-ta (P480067, gold corpus)
      5 nmod:after	=> us2-sa "(year) after" (4/5 => verb), egir +TERM "after (the harvest)" (1/5; = ePSD: egir buru14-sze3 "after the harvest")
      3 nmod:follow	=> us2-sa "(year) following" 2/2 => verb
      2 nmod:through=> -sze3 (TERM)
      2 nmod:per	=> sar (unit 2/2)
      2 nmod:on	=> tmod (2/2)
      2 nmod:into	=> L1 (2/2)
      2 nmod:at	=> LOC (two placenames, morphology unclear or intransparent)
      2 nmod:as	=> ERG argument of following verb (rendered as relative clause in the English translation)
      2 nmod:among	=> LOC (sza3 2/2)
      1 nmod:before	=> igi "(before the) eye of" + PN-sze3 (6/6)	[i.e., TERM]
      1 nmod:because (unclear)

Other dependencies:

	det 	"tir" 31/76 for PN "tir" PN => "PN took in charge the wood PN", gold/morph: "forester of" (could be modelled as epithet, then "nmod")
			"i7" = "river/canal" 7/76 (could be considered as epithet, then "nmod")
			"u4" = "day" 2/76 head must be fixed
			these are all nominals
	compound	"sila3" (liter) 178/561		mostly units (but not all)	=> nmod:unit
				"gin2" (shekels) 81/561
				"iti" (months)	33/561
				"sa" (bundles) 25/561
				"ma-na" (mana) 12/561
				"gur" (gur) 10/561
				
				P100765
				 im -compound-> nam-sza3-tam ("official tablets") =>
				 im <-amod- nam-sza3-tam
				 
	dobj	ABS
	nsubj	ERG (if ABS exists), ABS (otherwise)	
		[seem to be mostly unmarked, but sometimes, 
		these contain verbs (!)]
	
	  
## Todo
- check whether adjustments to [MTAAC/CDLI dependency guidelines](https://cdli-gh.github.io/annodoc/#syntactic-dependencies) are necessary/possible to facilitate the mappability of projected parses and MTAAC dependencies
- instead of merging just POS+MORPH and projected, perform automated syntax pre-annotation and merge then (cf. royal subcorpus). However, note that pre-annotation quality on native MTAAC annotations is worse than on royal corpus

## Contributors
- CC - Christian Chiarcos, Goethe-Universität Frankfurt, Germany
- IK - Ilya Khait, Goethe-Universität Frankfurt, Germany
- EPP - Emilie Page-Perron, U Toronto / UCLA

## History
- 2021-03-13 consolidated -- CC 
- 2020-10-31 published on GitHub -- CC
- 2019/2020 annotation projection -- CC and Goethe University MTAAC team
- 2017 corpus split -- IK
- 2017 CDLI export -- EPP

## Acknowledgments
MTAAC project (2017-2020)

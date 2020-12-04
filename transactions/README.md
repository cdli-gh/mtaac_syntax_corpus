Ur III transactions
=

This is the transaction subcorpus of the CDLI Ur III corpus, based on the integration of partial annotations drawn from
- the MTAAC transaction parser (https://github.com/cdli-gh/cfg-parser), applied to commodity annotations produced for CDLI Accounting Viz (https://github.com/cdli-gh/cdli-accounting-viz), and
- annotations projected from English translations 

In total, the transaction subcorpus covers 22,276 texts and 1,742,634 tokens. It consists of texts from the [MTAAC/CDLI Ur III corpus](https://github.com/cdli-gh/mtaac_cdli_ur3_corpus/tree/master/ur3_corpus_data) for which at least three commodities have been annotated by the commodity parser. The transaction corpus includes a subset of 263 files (27,395 tokens) with English translations.

The annotated data is to be provided in the `release/` directory. 
After initial creation of `release/` data, the data in this directory is subject to subsequent manual refinement which is expected to also reside in this directory.

In addition, all converters, the sources and results of major transformation processes and manual curation steps applied to the data during processing are provided in the directories

- `comm_conll/` excerpt of the MTAAC/CDLI Ur III corpus with automated commodity annotations, base data for the transaction subcorpus
- `psd/` semantic parse (transactions in phrase structures), generated from `comm_conll` using the MTAAC transaction parser
- TODO: `psd-deps/` heuristic export of `psd/` to MTAAC dependencies
- TODO: `preparsed/` heuristic annotation using the MTAAC dependency pre-annotator
- `parallel/` subcorpus of transactions with annotation projection from English translations
	- `parallel/projected` raw annotation projection from English
	- TODO: `parallel/consolidated` heuristic mapping of projected annotations to MTAAC specifications
	- TODO: `parallel/merged` merging between `psd-deps`, `parallel/consolidated` and `preparsed` (in that order)
- TODO: `nonparallel/` subcorpus of transactions without translations
	- TODO: `nonparallel/merged` merging between `psd-deps` and `preparsed`
- TODO: `release/` data release in CoNLL-CDLI format, combined from `parallel` and `nonparallel` 

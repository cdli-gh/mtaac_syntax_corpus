Ur III transactions
=

This is the transaction subcorpus of the CDLI Ur III corpus, based on the integration of partial annotations drawn from
- the MTAAC transaction parser (https://github.com/cdli-gh/cfg-parser), applied to commodity annotations produced for CDLI Accounting Viz (https://github.com/cdli-gh/cdli-accounting-viz), and
- annotations projected from English translations 

In total, the transaction subcorpus covers 25,179 texts and 2,322,224 tokens. It consists of texts from the [MTAAC/CDLI Ur III corpus](https://github.com/cdli-gh/mtaac_cdli_ur3_corpus/tree/master/ur3_corpus_data) for which at least three commodities have been annotated by the commodity parser.

The annotated data is to be provided in the `release/` directory. 
After initial creation of `release/` data, the data in this directory is subject to subsequent manual refinement which is expected to also reside in this directory.

In addition, all converters, the sources and results of major transformation processes and manual curation steps applied to the data during processing are provided in the directories

- `comm_conll/` excerpt of the MTAAC/CDLI Ur III corpus with automated commodity annotations, base data for the transaction subcorpus
- TODO: `parallel/` annotation projection from English translations
- TODO: `merged/` semiautomatic merging between transaction parses and projected annotations
- TODO: `release/` data release, with different sub-directories for merged and raw (transaction-only) annotations

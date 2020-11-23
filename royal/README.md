Ur III royal inscriptions
=

This is the royal subcorpus of the CDLI Ur III corpus, based on the integration of partial annotations drawn from
- an excerpt of the dependency parse of the ETCSRI corpus (Ur III section), see https://github.com/cdli-gh/mtaac-syntax-etscri for source data and acknowledgements, and
- annotations projected from English translations provided by CDLI (391 texts), resp. ETCSRI (223 texts).

The annotated data is provided in the `release/` directory. The (sub)corpus comprises 9,154 tokens and 614 texts. The data in this directory is subject to subsequent manual refinement which is expected to also reside in this directory.

In addition, all converters, the sources and results of major transformation processes and manual curation steps applied to the data during processing are provided in the directories

- `cdli/` CDLI-ATF and derived CoNLL files
- `etcsri/` ETCSRI corpus automated pre-annotation for syntactic dependencies (using an ETSCRI-specific pre-annotator) and its transformation to CDLI morphology
- `parallel/` annotation projection from English using CDLI or ETCSRI translations
- `merged/` semiautomatically merged files with original CDLI CoNLL, transformed ETCSRI annotation (forced alignment), transformed ETCSRI annotation (Levenshtein alignment), and projected annotations

TODO:
- add acknowledgments to MTAAC and ETCSRI
- add data subdirectory in release
- restore morphology for texts whose ETCSRI morphology is lost
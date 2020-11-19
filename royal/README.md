Ur III royal inscriptions
=

This is an excerpt of the dependency parse of the ETCSRI corpus (Ur III section), see https://github.com/cdli-gh/mtaac-syntax-etscri for source data and acknowledgements.
At the moment, we provide 

- `cdli/` CDLI-ATF and derived CoNLL files
- `etcsri/` ETCSRI corpus automated pre-annotation for syntactic dependencies (using an ETSCRI-specific pre-annotator) and its transformation to CDLI morphology
- `parallel/` annotation projection from English using CDLI or ETCSRI translations
- `merged/` merged file with original CDLI CoNLL, transformed ETCSRI annotation (forced alignment), transformed ETCSRI annotation (Levenshtein alignment), and projected annotations

TODO:
- adjust annotations to revised MTAAC conventions (e.g., replace DAT-H/DAT-NH with DAT, L1 with LOC, etc.)
- add acknowledgments to ETCSRI developers
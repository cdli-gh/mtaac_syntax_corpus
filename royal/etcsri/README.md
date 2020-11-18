# Ur III fraction of the ETCSRI corpus

rule-based dependency parse using ETCSRI morphology annotations

- `etcsri-conll/` CoNLL format following original ETCSRI conventions wrt. transliteration, morphology, and column structure
- `cdli-conll/` conversion of transliteration and morphology from `etcsri-conll/` to CDLI conventions
- `etscri2mtaac.py` converter script

## MTAAC conversion

Implemented using the `mtaac_package` (https://github.com/cdli-gh/mtaac-package). 
Note that we did not use the conventional `conll_file` class (from `CoNLL_file_parser.py`) because the ETSCRI *syntax* format is different from the MTAAC CoNLL version of ETSCRI *morphology* as expected by mtaac_package.

To run `etscri2mtaac.py`, perform the following steps

	$> git clone https://github.com/cdli-gh/mtaac-package.git
	$> cd mtaac-package
	$> # pip3 install pathos #	if not installed yet
	$> python3 setup.py install

The `cdli-conll/` directory was created with

	$> python3 etcsri2mtaac.py etcsri-conll/ cdli-conll/
	
Note that the result is not fully CDLI compatible as it preserves ORACC segmentation and certain transcription differences, e.g., in `kalag-ga` instead of `kal-ga` (P429946_Q001714).

## History
2020-11-18 conversion (CC+IK)

## Contributors

IK - Ilya Khait
CC - Christian Chiarcos
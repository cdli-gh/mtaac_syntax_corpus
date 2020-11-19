# Merged dependency annotations of the Ur-III corpus

Merging followed two objectives:

- impose CDLI transcription and segmentation principles onto ETCSRI corpus
- resort to projected annotations where ETCSRI-based pre-annotation does not apply 

	$> ./merge.sh ../cdli/conll/ ../etcsri/cdli-conll/ ../parallel/sux_projected/
	
## Content

- `raw/` direct merge (618 files)
- `curated/` manually revised edition of `raw/`

	every file with a RETOK was manually checked (134 in total)
	2 files with apparently incorrect CDLI links were renamed (CDLI ID replaced by P____)
	2 files without ETSCRI linking were removed (still contained in ../../parallel)
	for texts with *RETOK*, the alignment was checked
	only in exceptional cases, the annotations have been corrected
	
It is to be noted that ETCSRI and CDLI editions of the same text often deviate substantially, with ETCSRI texts sometimes massively amended. A systematic difference is treatment of *nita* "male" and *lugal* "ruler". In 5 cases, CDLI has *lugal* where ETCSRI has *nita*, in 4 cases, ETCSRI has *nita* where CDLI has *lugal*.
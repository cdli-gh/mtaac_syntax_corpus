
# Merged dependency annotations of the Ur-III corpus

Merging followed two objectives:

- impose CDLI transcription and segmentation principles onto ETCSRI corpus
- resort to projected annotations where ETCSRI-based pre-annotation does not apply 
	
## Content

- `raw/` direct merge (618 files)
	created using 
	
		$> ./merge.sh ../cdli/conll/ ../etcsri/cdli-conll/ ../parallel/sux_projected/

- `curated/` manually revised edition of `raw/`

	partial manual checks
	- 134 files with `*RETOK*` manually checked for alignment
	- 2 files with apparently incorrect CDLI links were renamed (CDLI ID replaced by `P____`)
	- 3 files without ETSCRI linking were removed (still contained in `../../parallel`)
	- 81 files in which column 23 did not contain dependency labels manually corrected 
	
	It is to be noted that ETCSRI and CDLI editions of the same text often deviate substantially, with ETCSRI texts sometimes massively amended. A systematic difference is treatment of *nita* "male" and *lugal* "ruler". In 5 cases, CDLI has *lugal* where ETCSRI has *nita*, in 4 cases, ETCSRI has *nita* where CDLI has *lugal*.
	
	Over the curated data, we can compare projected and pre-annotated labels, with the most  frequent mappings (accounting for 50% per projected dependency)
	
	| projected | pre-annotated	| percentage | CDLI mapping | UD mapping | 
	| --------- | ------------- | ---------- | ------------ | ---------- |
	| `acl`*     | none (`_`, `?`) | 0.75 = 58/77  |	`acl` | `acl` |
	| `acl:relcl`* | none (`_`, `?`) | 0.78 = 208/267 | `acl` | `acl` |
	| `advcl`*   | none (`_`, `?`) | 0.89 = 33/37 |	`acl+ADV` | `advcl`|
	| `ccomp`*   | none (`_`, `?`) | 0.90 = 18/20 |	`parataxis`   | `parataxis`|
	| `cop`*,+	 | none (`_`, `?`) | 1.00 = 3/3 | manually       |  |
	| `csubj`*   | none (`_`)      | 0.50 = 2/4 | `ccomp` (exclusively for naming)  | `ccomp` |
	| `parataxis`* | none           | 0.97 = 30/31 | `parataxis` | `parataxis` |
	| `xcomp`*    | none            | 0.67 = 6/9 | `acl`     | `acl` |
	| `aux`, `auxpass`+ | none (`_`, `?`) | 0.69 = 11/16 | manually | |
	| `cc`+		 | `cc`			   | 0.03 = 8/293 | | |
	| `cc`+       | case or `appos` | 0.59 = 173/293 | `appos` | `appos` |
	| `compound`+ | none (`_`, `?`) | 0.78 = 36/46 |
	| `compound`+ | case or `appos` | 0.21 = 18/46 | `appos` | `appos` |
	| `det`+      | `amod`          | 0.50 = 96/193 | | |
	| `det`+      | case or `appos` | 0.29 = 56/193 | `appos` | `appos`|
	| `det`+      | none (`_` or `?`) | 0.21 = 41/193 | | |
	| `dep`++      | none (`_` or `?`) | 0.98 = 157/161 | `dep` | `dep` |
	| `mark`+     | none (`_` or `?`) | 0.89 = 42/47 | manually | |	
	| `advmod`  | none (`_`, `?`) | 0.55 = 12/22 | manually |  |
	| `amod`    | `amod`          | 0.43 = 31/72 | `amod`   | `amod` |
	| `amod`    | none (`_`, `?`) | 0.39 = 28/72 | | |
	| `nummod`++  | none            | 0.88 = 67/76 | `nummod` | `nummod` |
	| `appos`   | `appos`         | 0.56 = 880/1576 | `appos` | `appos` |
	| `appos`   | case            | 0.20 = 318/1576 | ||
	| `conj`+    | `appos`         | 0.32 = 69/214 | `appos` | |
	| `conj`+	 | case			  | 0.11 = 24/214 | | |
	| `conj`+    | `conj`		  | 0.03 = 6/214 | | |
	| `dobj`   | `ABS` or `appos` | 0.49 = 46/94 | `ABS` | `dobj` (if `ERG`), `nsubj` (otherwise) |
	| `dobj`   | none (`_` or `?`) | 0.46 = 43/94 | | |
	| `nmod:as` | `LOC`           | 0.30 = 3/10 | `LOC` | `obl` |
	| `nmod:at` | none (`_` or `?`) | 0.85 = 11/13 | `LOC` | `obl` |
	| `nmod:by` | `ERG` or `appos`| 0.27 = 8/30 | `ERG` | `nsubj` |
	| `nmod:by` | none            | 0.50 = 15/30 | | |
	| `nmod:for` | `TERM`		  | 0.31 = 28/91 | `DAT` | `iobj` |
	| `nmod:for` | `DAT`          | 0.23 = 21/91 | ||
	| `nmod:from` | `ABL` or  `appos` | 0.38 = 3/8 | `ABL` | `obl` |
	| `nmod:in`  | `LOC` or  `appos` | 0.47 = 23/49 | `LOC` | `obl`|
	| `nmod:like` | `EQU`         | 0.13 = 1/8 | `EQU`  | `nmod`/`obl` |
	| `nmod:like` | none          | 0.63 = 5/8 | `EQU`  | `nmod`/`obl` |
	| `nmod:of`   | `GEN` or `appos` | 0.66 = 704/1063 | `GEN` | `nmod` |
	| `nmod:over` | `LOC`         | 1.00 = 1/1 | `LOC` | `obl` |
	| `nmod:poss` | `appos` or case | 0.28 = 8/29 | manually | |
	| `nmod:poss` | none          | 0.55 = 16/29 | ||
	| `nmod:to`   | `DAT`         | 0.18 = 10/56 | `LOC` | `obl` |
	| `nmod:to`   | `LOC`         | 0.09 = 5/56 | | |
	| `nmod:to`   | `appos`       | 0.05 = 3/56 | | | 
	| `nmod:within` | `LOC`       | 0.50 = 1/2 | `LOC` | `obl` |
	| `nsubj`     | `appos`       | 0.17 = 52/303 | `ABS` (if no `dobj`), `ERG` (if `dobj`) | see `ABS` |
	| `nsubj`     | `ABS`         | 0.04 = 12/303 | ||
	| `nsubj`     | `ERG`, `GEN.ERG`  | 0.04 = 12/303 | ||
	| `nsubjpass` | none         | 0.84 = 16/19 | `ABS` | see `ABS` |
	| `nsubjpass` | `ABS` or `appos` | 0.16 = 3/19 | ||
	
	
		* Clausal structures are not covered by pre-annotation.
		+ These should not exist, be rare or necessarily different than the Sumerian counterpart.
		++ These labels are not projected but assigned in projection postprocessing to fragments (`dep`) and numerals (`nummod`).
	
	
- `consolidated/`
	

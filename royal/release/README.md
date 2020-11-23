# MTAAC/CDLI dependency annotations of the Ur-III royal subcorpus

Release version of syntactic dependencies for the royal subcorpus of the MTAAC/CDLI Ur-III corpus, based on ETCSRI morphology, annotation projection and the syntactic pre-annotation developed in the MTAAC project. At the moment, the data has *silver* (not gold) quality: It is produced by a semiautomated method over manually created annotations and awaits manual verification. Further improvement by automated methods is not expected. The data in this directory is subject to manual refinement.

For the raw data underlying the annotations provided here, see `../merged/consolidated`. Two files with incorrect CDLI linking have been omitted.

## Data quality

At the moment, the data has *silver* (not gold) quality: It is produced by a semiautomated method over manually created annotations and awaits manual verification. In particular, 13% of the tokens (1223) carry no dependency label and need to be manually revised. As the following example (P315451) shows, this is largely due to m:1 alignments between the CDLI primary data, the ETCSRI corpus from which we inherit the underlying morphology annotation and the English translation that is the basis for annotation projection:

	# global.columns = ID WORD SEGM POS MORPH HEAD EDGE MISC
	# tr.en: ruler of Laga built his E-dura
	1       ...-x-x _[_]    u       u       7       dep     _
	2       ensi2   ensi2[ruler]    N       N       7       ERG     _
	3       lagasz{ki}-ke4  lagasz{ki}[1]   SN      SN.GEN.ERG      2       GEN     _
	4       e2      _       _       _       7       _       _
	5       ansze   _       _       _       7       _       _
	6       dur9{ur3}-ka-ni e2-{ansze}du24-ur3[1]   TN      TN.3-SG-H-POSS.ABS      7       ABS     _
	7       mu-na-du3       du3[build]      V       VEN.3-SG-H.DAT.3-SG-H-A.V.3-SG-P        0       root    _

Here, the ETCSRI corpus treated *e2-{ansze}dur9{ur3}-ka-ni* as a single token (and provides a single `SEGM` annotation for it). Likewise, the translation only provides a single token to render the name in English (*E-dura*, in the `tr.en` row), so that no annotations for its components can be projected. The unattached tokens have been heuristically attached, but are marked with the empty label `_`. In this case, the resulting attachment is also incorrect (correct would be `e2 -nmod-> [ansze -nmod-> dur9{ur3}-ka-ni]`). Otherwise, the parse is correct.

Another source of unlabelled dependencies are cycles that result from the interweaving of ETCSRI-based and projected annotations. These cycles have been repaired so that all annotated data comes in valid trees, but this repair can result in detaching words that are then heuristically re-integrated with the tree.
	
For another 67 tokens (0.7%), projectivity violations are documented. These arise from word order differences between Sumerian and English and can only be manually corrected.

Furthermore, note that also apparently valid annotations can be error-prone. In the example above, the automated alignment may decide to link, say, *ansze* with *his* because of their position relative to the CDLI token aligned with *E-dura*. However, the actual counterpart of *his* is the morpheme *-ani* in *dur9{ur3}-ka-ni* whereas *ansze* is a determinative (an orthographic category not found in English). Any annotation projected on this basis would be incorrect.

Finally, the English parser may struggle with domain specifics of the English translations. For example, gaps in the text may show up in the translation as *...* and treated like punctuation. As a compensation, before annotation projection the English translation has been repaired by inserting the phrase *something* for any gap. While this yields acceptable results for many nominals (which are the majority in the corpus), this will lead to incorrect parses for omissions of verbs. In those cases, the original annotations projected to Sumerian may already be incorrect. In the projected annotation, dependency labels of fragments are normalized (in accordance with annotation guidelines) to `dep`, so that the correct dependency label is guaranteed, but the the overall structure of the parse may be affected as a consequence.

## History

- 2020-11-22 initialized with annotations from `../merged/consolidated`.

## Acknowledgements and Licensing

MTAAC (see root directory) and ETSCRI morphology (see parent directory)

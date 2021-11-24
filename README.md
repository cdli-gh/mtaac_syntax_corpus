# MTAAC Corpus of Syntactically Annotated Sumerian

Dependency syntax for Sumerian, Ur III corpus. 

Our syntax annotations come in CDLI-CoNLL, a tabular (TSV) format with specifications similar to CoNLL-U, but different column structure and a domain-specific annotation scheme.

## Format

columns:

- `ID` token number within the sentence
- `WORD` transliteration
- `SEGM` normalization, optional glossing information
- `POS` original part of speech or named entity tag
- `MORPH` morphological gloss, with `.`-separated features in the order of the associated morphemes, the morphological head is marked by the part of speech tag. Note that the granularity of information provided in this column varies across individual subcorpora.
- `HEAD` head of the dependency relation
- `EDGE` label of the dependency relation, as documented in the [annotation guidelines](doc)
- `MISC` comments, e.g., provenance or debug information for the annotation

sample (P430477): *Ibi-Suen, strong king, king of Ur, king of the four quarters; Shulgili, the scribe, [is] your slave.*

    1   {d}i-bi2-{d}suen {d}i-bi2-{d}suen[1]   RN  RN                        0       root    _
    2   lugal            lugal[king]           N   N                         1       appos   _
    3   kal-ga           kalag[strong]         V   NF.V.PT                   2       amod    _
    4   lugal            lugal[king]           N   N                         1       appos   _
    5   uri5{ki}-ma      urim5{ki}[1]          SN  SN.GEN                    4       GEN     _
    6   lugal            lugal[king]           N   N                         1       appos   _
    7   an                _                    N   N                         8       mwe     _
    8   ub-da             an-ub-da[quarter]    N   N                         6       GEN     _
    9   limmu2-ba         limmu2[four]         NU  NF.V.3-SG-NH-POSS.GEN.ABS 8       nummod  _
    10  {d}szul-gi-i3-li2 {d}szul-gi-i3-li2[6] PN  PN                        12      ABS     _
    11  dub-sar           dub-sar[scribe]      N   N.ABS                     10      appos   _
    12  ARAD2-zu          arad2[slave]         N   N.2-SG-POSS.ABS           1       acl     _

Note that Sumerian phrasal structure is to a large extend encoded in the morphology, and there such information is available, the syntactic analysis respects the existing morphological annotation. Here, Shulgili is annotated (on its dependent, *dub-sar*) with absolutive case, indicating that it is a clausal argument of a following predicate. Without any verbal predicate in the clause, we must assume that the final word *ARAD2-zu* is the predicate of an (implicit) copular clause. As it is also annotated with absolutive case, this indicates that it is an adnominal modifier (hence `acl`) of a preceding noun.

However, as absolutive case is marked by a zero morpheme, the copula is implicit (morphologically unmarked) and the writing of case marking is deficient in the Sumerian Ur-III data, alternative analyses of the same textual input are possible, e.g., the analysis of Ibi-Suen as vocative argument of the copular clause. However, for this analysis, we would expect the first word to be annotated as `RN.ABS` and the last word as `N.2-SG-POSS`.

## Subcorpora

- [reference-data](reference-data) manually analyzed sample data from corpus and literature, used for tagset design and annotation evaluation
- [pre-annotated](pre-annotated) MTAAC Gold corpus with [manual annotations](https://github.com/cdli-gh/mtaac_gold_corpus/tree/workflow/morph/to_dict) for morphology and [automated annotations](https://github.com/cdli-gh/mtaac_work/tree/master/parse) for syntax
- [royal](royal) Ur III section of the ETSCRI corpus (bootstrapped from ETSCRI morphology, complemented with annotation projection from translations)
- [parallel](parallel) parallel section of the CDLI Ur III corpus with automated morphological annotations and dependency syntax extrapolated from projected annotations of English translations
- [transactions](transactions) subcorpus of administrative texts describing the exchange of commodities from the CDLI Ur III corpus, partial automated annotation for transactions and their participants

Note that our materials and data for syntax annotation as still being consolidated. In particular, this includes the results of the commodity parser and from annotation projection.

## Other data

- [doc](doc) annotation guidelines for dependency syntax in Sumerian, designed for mappability to UD v.2
- [parser](parser) experimental CoNLL-U export and experiments for training off-the-shelf UD parsers over CDLI data



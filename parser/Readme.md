# train CoNLL-U parser

Build CoNLL-U training data:

	$> ./build.sh

Install and compile UDPipe (v.1, for the moment) under ./udpipe, see https://wiki.apertium.org/wiki/UDPipe

Train UDPipe:

	$> ./udpipe/src/udpipe udpipe.model --train train.conllu	

Evaluate UDPipe

	$> ./udpipe/src/udpipe --accuracy --tag udpipe.model test.conllu
	$> ./udpipe/src/udpipe --accuracy --parse udpipe.model test.conllu

etc.

Use UDPipe on existing CoNLL data:

	$> cut -f 1,2 test.conllu | \
           sed s/'^[^#].*'/'&\t\_\t_\t_\t_\t_\t_\t_\t_'/ | \
           ./udpipe/src/udpipe -tag -parse udpipe.model 

We provide the trained model file, so you can run UDPipe directly on tokenized data. Note that it requires integer ids.

Use UDPipe on plain text:

	$> cut -f 2 test.conllu | grep -v '#' | perl -pe 's/([^\n])\n/$1 /g;' | egrep . | \
	   ./udpipe/src/udpipe --input=horizontal udpipe.model --tag --parse

(The second line is the call to the parser. The first line produces one text per line from the original CoNLL data.)

Results

| flag          | score          | value | comment                         |   
|---------------|----------------|-------|---------------------------------|
| --tag         | accuracy, UPOS | 94.2% | tagging using gold tokenization |
|               | accuracy, XPOS | 93.3% |                                 |
| --parse       | UAS            | 41.9% | parsing using gold POS          |
|               | LAS            | 35.8% |                                 |
| --tag --parse | UAS            | 41.0% | parsing using gold tokenization |
|               | LAS            | 35.3% |                                 |

Note that UDpipe v.1 is not a state-of-the-art system, but just chosen because of simplicity and speed.
This is a mere baseline for future comparison.

However, note that Sumerian morphology is challenging:
- It is complex, with an idiosyncratic writing system, so a word-based system such as UDpipe v.1 will have difficulties to generalize over the sparse training data we have available.
- Sumerian syntax is to a large extent encoded in the morphology *of dependents*. This is almost a unique feature of Sumerian. Long-distance effects from morphology are normally not taken into consideration by SOTA parsers. 








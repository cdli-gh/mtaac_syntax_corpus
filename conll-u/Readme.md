# train CoNLL-U parser

Build CoNLL-U training data:

	$> ./build.sh

Install and compile UDPipe (v.1, for the moment) under ./udpipe, see https://wiki.apertium.org/wiki/UDPipe

Train UDPipe:

	$> udpipe/src/udpipe udpipe1.model --train train.conllu	


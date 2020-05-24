#!/bin/bash

LANGUAGE=$1

python3 src/fairseq_format.py $LANGUAGE

fairseq-preprocess \
    --source-lang="${LANGUAGE}.input" \
    --target-lang="${LANGUAGE}.output" \
    --trainpref=train \
    --validpref=dev \
    --testpref=test \
    --tokenizer=space \
    --thresholdsrc=1 \
    --thresholdtgt=1 \
    --destdir="data-bin/${LANGUAGE}/"

#rm *.input *.output

DATADIR="data/${LANGUAGE}"

mkdir -p $DATADIR

mv *".${LANGUAGE}."* $DATADIR

#!/bin/bash

# Usage:
# ./src/runAll_large.sh large

set -euo pipefail

TYPE=$1

echo ==========$TYPE========== >> results_$TYPE.txt


for LANGUAGE in pei nno vec nob dan tuk otm ote san glg frm uzb fas est ang hin nld sme olo mdf cat isl swe kpv mhr myv krl eng udm vep fin deu; do

    echo $LANGUAGE
    
    echo "----start time----" >> results_$TYPE.txt

    date >> results_$TYPE.txt

    echo "... preprocessing data ..."
    ./src/preprocess_large.sh $LANGUAGE

    # train for 10000 updates, select best five model on dev so far
    echo "... training models ..."
    ./src/train.sh $LANGUAGE 10000

    echo "... generating and evaluating for dev set ..."
    ./src/generate.sh $LANGUAGE dev $TYPE

    # continue training for another 10000 updates, select best five model on dev so far
    echo "... training models ..."
    ./src/train.sh $LANGUAGE 20000

    echo "... generating and evaluating for dev set ..."
    ./src/generate.sh $LANGUAGE dev $TYPE

    # IF NEEDED,
    # continue training for another 10000 updates, select best five model on dev so far
    # echo "... training models ..."
    # ./src/train.sh $LANGUAGE 30000

    # echo "... generating and evaluating for dev set ..."
    # ./src/generate.sh $LANGUAGE dev $TYPE

    # generate for test data
    echo "... generating and evaluating for test set ..."
    ./src/generate.sh $LANGUAGE test $TYPE

    mkdir -p "checkpoints-${TYPE}/"
    mkdir -p "data-bin-${TYPE}/"

    mv "checkpoints/${LANGUAGE}"* "checkpoints-${TYPE}/"
    mv "data-bin/${LANGUAGE}"* "data-bin-${TYPE}/"

    echo "----end time----" >> results_$TYPE.txt

    date >> results_$TYPE.txt

done


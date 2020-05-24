#!/bin/bash

# Usage:
# ./src/runAll.sh 1src

set -euo pipefail

TYPE=$1

echo ==========$TYPE========== >> results_$TYPE.txt


#for LANGUAGE in hil gmh zpv tgl; do
#for LANGUAGE in zpv tgl; do
#for LANGUAGE in tgk dje mao lin xno lud zul sot vro ceb mlg gmh kon gaa izh mwf zpv kjh hil gml tel vot czn ood mlt gsw orm tgl sna frr syc xty ctp dak liv aka ben; do
for LANGUAGE in tgk dje mao lin xno lud zul sot vro ceb mlg gmh kon gaa izh mwf zpv kjh hil gml tel vot czn ood mlt gsw orm tgl sna frr syc xty ctp dak liv aka ben nya cly swa lug bod kan kir cre pus lld ast crh cpa uig fur evn aze kaz azg urd bak; do

    echo $LANGUAGE
    
    echo "----start time----" >> results_$TYPE.txt

    date >> results_$TYPE.txt

    echo "... preprocessing data ..."
    ./src/preprocess.sh $LANGUAGE $TYPE

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


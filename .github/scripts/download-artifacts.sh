#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

RUN_ID=$1

for ARG in "${@:2}"; do
    NEEDS=`echo "$ARG" | /mingw64/bin/jq 'keys|join(" ")' | sed 's/"//g'`
    for NEED in $NEEDS; do
        echo "Downloading $NEED artifact."
        /mingw64/bin/gh run download $RUN_ID -n $NEED || true
    done
done

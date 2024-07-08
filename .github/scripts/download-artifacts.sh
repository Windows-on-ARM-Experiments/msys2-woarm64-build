#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

RUN_ID=$1
NEEDS=`echo "$2" | /mingw64/bin/jq 'keys|join(" ")' | sed 's/"//g'`

for NEED in $NEEDS; do
    echo "Downloading $NEED artifact."
    /mingw64/bin/gh run download $RUN_ID -n $NEED
done

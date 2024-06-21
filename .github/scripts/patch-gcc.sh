#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

if [ -z "$GITHUB_WORKSPACE" ]; then
  DIR=`pwd`
else
  DIR=`cygpath "$GITHUB_WORKSPACE"`
fi

SRC_DIR=$DIR/gcc

pushd $SRC_DIR
    git reset --hard
    git clean -fdx
    patch -p1 -i $DIR/patches/gcc/0001-workarounds.patch
popd

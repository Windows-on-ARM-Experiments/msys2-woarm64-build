#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

if [ -z "$GITHUB_WORKSPACE" ]; then
  DIR=`pwd`
else
  DIR=`cygpath "$GITHUB_WORKSPACE"`
fi

BUILD_DIR=$DIR/gcc-build
INSTALL_DIR=$DIR/gcc-install
TEST_RESULTS_DIR=$DIR/gcc-test-results

PATH="$PATH:/opt/bin:/opt/aarch64-w64-mingw32/bin"

pushd $BUILD_DIR
    make -k -j$(nproc) check

    mkdir -p $TEST_RESULTS_PATH
    rm -rf $TEST_RESULTS_PATH/*

    for FILE in `find $GCC_BUILD_PATH -path '*testsuite*.log' -or -path '*testsuite*.sum'`; do
        cp $FILE $TEST_RESULTS_PATH/
    done
popd

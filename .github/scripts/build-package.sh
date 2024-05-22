#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

PACKAGE_REPOSITORY=$1

ARGUMENTS="--syncdeps \
    --rmdeps \
    --cleanbuild \
    --noconfirm \
    --noprogressbar \
    --nocheck \
    --force"

if [[ "$PACKAGE_REPOSITORY" == *MINGW* ]]; then
    MINGW_ARCH=mingw64 makepkg-mingw $ARGUMENTS --skippgpcheck
else
    makepkg $ARGUMENTS
fi

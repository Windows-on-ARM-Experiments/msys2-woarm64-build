#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

PACKAGE_REPOSITORY=$1

CLEAN_BUILD=${CLEAN_BUILD:-0}
INSTALL_PACKAGE=${INSTALL_PACKAGE:-0}
NO_EXTRACT=${NO_EXTRACT:-0}

ARGUMENTS="--syncdeps \
    --rmdeps \
    --noconfirm \
    --noprogressbar \
    --nocheck \
    --skippgpcheck \
    --force \
    $([ "$NO_EXTRACT" = 1 ] && echo "--noextract" || echo "") \
    $([ "$CLEAN_BUILD" = 1 ] && echo "--cleanbuild" || echo "") \
    $([ "$INSTALL_PACKAGE" = 1 ] && echo "--install" || echo "")"

ccache -svv  || true

if [[ "$PACKAGE_REPOSITORY" == *MINGW* ]]; then
    makepkg-mingw $ARGUMENTS
else
    makepkg $ARGUMENTS
fi

ccache -svv || true

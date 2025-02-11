#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

PACKAGE_REPOSITORY=$1

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

if command -v ccache &> /dev/null; then
    echo "::group::Ccache statistics before build"
        ccache -svv  || true
    echo "::endgroup::"
fi

echo "::group::Build package"
    if [[ "$PACKAGE_REPOSITORY" == *MINGW* ]]; then
        makepkg-mingw $ARGUMENTS
    else
        makepkg $ARGUMENTS
    fi
echo "::endgroup::"

if command -v ccache &> /dev/null; then
    echo "::group::Ccache statistics after build"
        ccache -svv || true
    echo "::endgroup::"
fi

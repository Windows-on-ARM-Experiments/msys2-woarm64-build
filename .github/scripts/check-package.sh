#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

PACKAGE_REPOSITORY=$1

INSTALL_PACKAGE=${INSTALL_PACKAGE:-0}
NO_EXTRACT=${NO_EXTRACT:-1}
NO_ARCHIVE=${NO_ARCHIVE:-1}

ARGUMENTS="--syncdeps \
  --rmdeps \
  --noconfirm \
  --noprogressbar \
  --skippgpcheck \
  --recheck \
  --force \
  $([ "$NO_EXTRACT" = 1 ] && echo "--noextract" || echo "") \
  $([ "$NO_ARCHIVE" = 1 ] && echo "--noarchive" || echo "") \
  $([ "$INSTALL_PACKAGE" = 1 ] && echo "--install" || echo "")"

echo "::group::Check package"
  if [[ "$PACKAGE_REPOSITORY" == *MINGW* ]]; then
    makepkg-mingw $ARGUMENTS
  else
    makepkg $ARGUMENTS
  fi
echo "::endgroup::"

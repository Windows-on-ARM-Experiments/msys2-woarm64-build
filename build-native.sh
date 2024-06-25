#!/bin/bash

set -e # exit on error
set -x # echo on

CLEAN_BUILD=${CLEAN_BUILD:-0}

pacman -S --noconfirm base-devel

echo "::group::Build mingw-w64-headers-git"
  pushd ../MINGW-packages/mingw-w64-headers-git
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-bzip2"
  pushd ../MINGW-packages/mingw-w64-bzip2
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-zlib"
  pushd ../MINGW-packages/mingw-w64-zlib
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-xz"
  pushd ../MINGW-packages/mingw-w64-xz
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-libxml2"
  pushd ../MINGW-packages/mingw-w64-libxml2
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-libiconv"
  pushd ../MINGW-packages/mingw-w64-libiconv
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-libtre-git"
  pushd ../MINGW-packages/mingw-w64-libtre-git
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-libsystre"
  pushd ../MINGW-packages/mingw-w64-libsystre
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-ncurses"
  pushd ../MINGW-packages/mingw-w64-ncurses
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-gettext"
  pushd ../MINGW-packages/mingw-w64-gettext
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-binutils"
  pushd ../MINGW-packages/mingw-w64-binutils
    .github/scripts/build-package.sh MINGW
  popd
echo "::endgroup::"

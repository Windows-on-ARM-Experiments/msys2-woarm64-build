#!/bin/bash

set -e # exit on error
set -x # echo on

if [[ "$MSYSTEM" != "MINGWARM64" ]]; then
  echo "This script must be run in the MSYS2 MINGWARM64 shell"
  exit 1
fi

ROOT_DIR=`dirname ${BASH_SOURCE[0]}`
ROOT_DIR=`realpath $ROOT_DIR`
CLEAN_BUILD=${CLEAN_BUILD:-0}

function build_package () {
  PACKAGE=$1
  echo "::group::Build $PACKAGE"
    pushd ../MINGW-packages/$PACKAGE
      rm -rf *.pkg.tar.zst
      rm -rf src/
      INSTALL_PACKAGE=1 \
        $ROOT_DIR/.github/scripts/build-package.sh MINGW
    popd
  echo "::endgroup::"
}

./clean-native.sh

pacman -S --noconfirm \
  base-devel \
  mingw-w64-cross-mingwarm64-gcc \
  mingw-w64-cross-mingwarm64-windows-default-manifest \
  mingw-w64-x86_64-gcc-libs

build_package mingw-w64-libiconv
build_package mingw-w64-libtre-git
build_package mingw-w64-libsystre
build_package mingw-w64-ncurses
build_package mingw-w64-gettext
build_package mingw-w64-bzip2
build_package mingw-w64-zlib
build_package mingw-w64-zstd
build_package mingw-w64-gmp
build_package mingw-w64-mpfr
build_package mingw-w64-isl
build_package mingw-w64-mpc

build_package mingw-w64-headers-git
build_package mingw-w64-crt-git
build_package mingw-w64-winpthreads-git
build_package mingw-w64-binutils
build_package mingw-w64-windows-default-manifest
build_package mingw-w64-gcc

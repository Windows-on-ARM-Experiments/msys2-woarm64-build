#!/bin/bash

set -e # exit on error
set -x # echo on

if [[ "$MSYSTEM" != "MSYS" ]]; then
  echo "This script must be run in the MSYS2 MSYS shell"
  exit 1
fi

ROOT_DIR=`dirname ${BASH_SOURCE[0]}`
ROOT_DIR=`realpath $ROOT_DIR`
CLEAN_BUILD=${CLEAN_BUILD:-0}

function build_package () {
  PACKAGE=$1
  echo "::group::Build $PACKAGE"
    pushd ../MSYS2-packages/$PACKAGE
      rm -rf *.pkg.tar.zst
      rm -rf src/
      if [[ "$PACKAGE" == mingw-w64-cross-mingwarm64-crt ]]; then
        $ROOT_DIR/.github/scripts/pthread-headers-hack-before.sh
      fi
      if [[ "$PACKAGE" == mingw-w64-cross-mingwarm64-gcc ]]; then
        $ROOT_DIR/.github/scripts/build-package.sh MSYS2
        pacman -R --noconfirm mingw-w64-cross-mingwarm64-gcc-stage1 || true
        pacman -U --noconfirm *.pkg.tar.zst
      else
        INSTALL_PACKAGE=1 \
          $ROOT_DIR/.github/scripts/build-package.sh MSYS2
      fi
      if [[ "$PACKAGE" == mingw-w64-cross-mingwarm64-crt ]]; then
        $ROOT_DIR/.github/scripts/pthread-headers-hack-after.sh
      fi
    popd
  echo "::endgroup::"
}

./clean-cross.sh

pacman -S --noconfirm \
  base-devel

build_package mingw-w64-cross-mingwarm64-headers
build_package mingw-w64-cross-mingwarm64-binutils
build_package mingw-w64-cross-mingwarm64-gcc-stage1
build_package mingw-w64-cross-mingwarm64-windows-default-manifest
build_package mingw-w64-cross-mingwarm64-crt
build_package mingw-w64-cross-mingwarm64-winpthreads
build_package mingw-w64-cross-mingwarm64-gcc
build_package mingw-w64-cross-mingwarm64-zlib

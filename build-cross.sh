#!/bin/bash

export FLAVOR=CROSS
export CLEAN_BUILD=1

source `dirname ${BASH_SOURCE[0]}`/config.sh

if [[ "$MSYSTEM" != "MSYS" ]]; then
  echo "This script must be run in the MSYS2 MSYS shell"
  exit 1
fi

ROOT_DIR=`dirname ${BASH_SOURCE[0]}`
ROOT_DIR=`realpath $ROOT_DIR`

function build_package () {
  PACKAGE=$1
  REPOSITORY=${2:-MSYS2}
  echo "::group::Build $PACKAGE"
    pushd ../$REPOSITORY-packages/$PACKAGE
      if [[ "$PACKAGE" == mingw-w64-cross-mingwarm64-crt ]]; then
        $ROOT_DIR/.github/scripts/pthread-headers-hack-before.sh
      fi
      if [[ "$PACKAGE" == mingw-w64-cross-mingwarm64-gcc ]]; then
        $ROOT_DIR/.github/scripts/build-package.sh $REPOSITORY
        pacman -R --noconfirm mingw-w64-cross-mingwarm64-gcc-stage1 || true
        pacman -U --noconfirm *.pkg.tar.zst
      else
        INSTALL_PACKAGE=1 \
          $ROOT_DIR/.github/scripts/build-package.sh $REPOSITORY
      fi
      if [[ "$PACKAGE" == mingw-w64-cross-mingwarm64-crt ]]; then
        $ROOT_DIR/.github/scripts/pthread-headers-hack-after.sh
      fi
    popd
  echo "::endgroup::"
}

.github/scripts/clean-cross.sh
.github/scripts/install-dependencies.sh
.github/scripts/enable-ccache.sh

build_package mingw-w64-cross-mingwarm64-headers
build_package mingw-w64-cross-mingwarm64-binutils
build_package mingw-w64-cross-mingwarm64-gcc-stage1
build_package mingw-w64-cross-mingwarm64-windows-default-manifest
build_package mingw-w64-cross-mingwarm64-crt
build_package mingw-w64-cross-mingwarm64-winpthreads
build_package mingw-w64-cross-mingwarm64-gcc
build_package mingw-w64-cross-mingwarm64-zlib

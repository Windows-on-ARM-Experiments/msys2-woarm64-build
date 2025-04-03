#!/bin/bash

export FLAVOR=NATIVE_WITH_NATIVE
export CLEAN_BUILD=1

source `dirname ${BASH_SOURCE[0]}`/config.sh

if [[ "$MSYSTEM" != "MINGWARM64" ]]; then
  echo "This script must be run in the MSYS2 MINGWARM64 shell"
  exit 1
fi

ROOT_DIR=`dirname ${BASH_SOURCE[0]}`
ROOT_DIR=`realpath $ROOT_DIR`

function build_package () {
  PACKAGE=$1
  REPOSITORY=${2:-MINGW}
  echo "::group::Build $PACKAGE"
    pushd ../$REPOSITORY-packages/$PACKAGE
      INSTALL_PACKAGE=1 \
        $ROOT_DIR/.github/scripts/build-package.sh $REPOSITORY
    popd
  echo "::endgroup::"
}

.github/scripts/setup-repository.sh
.github/scripts/setup-mingwarm64.sh

.github/scripts/clean-native.sh
.github/scripts/install-dependencies.sh
.github/scripts/enable-ccache.sh

build_package mingw-w64-libtool
build_package mingw-w64-ninja
build_package mingw-w64-pkgconf
build_package mingw-w64-autotools
build_package autotools-wrappers MSYS2
build_package mingw-w64-gperf
build_package mingw-w64-libiconv
build_package mingw-w64-libtre
build_package mingw-w64-libsystre
build_package mingw-w64-gettext
build_package mingw-w64-ncurses
build_package mingw-w64-bzip2
build_package mingw-w64-zlib
build_package mingw-w64-zstd
build_package mingw-w64-gmp
build_package mingw-w64-mpfr
build_package mingw-w64-isl
build_package mingw-w64-mpc

build_package mingw-w64-libmangle-git
build_package mingw-w64-tools-git
build_package mingw-w64-headers-git
build_package mingw-w64-crt-git
build_package mingw-w64-winpthreads-git
build_package mingw-w64-binutils
build_package mingw-w64-windows-default-manifest
build_package mingw-w64-gcc

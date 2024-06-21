#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

if [ -z "$GITHUB_WORKSPACE" ]; then
  DIR=`pwd`
else
  DIR=`cygpath "$GITHUB_WORKSPACE"`

  echo "CCACHE_DIR=$DIR/ccache" >> "$GITHUB_ENV"
  echo "timestamp=$(date -u --iso-8601=seconds)" >> "$GITHUB_OUTPUT"
fi

if [ -d /usr/lib/ccache/bin ]; then
  echo "::group::Add aarch64 toolchain to ccache"
    pushd /usr/lib/ccache/bin/
      MSYS=winsymlinks
      unlink aarch64-w64-mingw32-gcc || true
      unlink aarch64-w64-mingw32-g++ || true
      unlink aarch64-w64-mingw32-c++ || true
      ln -s /usr/bin/ccache aarch64-w64-mingw32-gcc
      ln -s /usr/bin/ccache aarch64-w64-mingw32-g++
      ln -s /usr/bin/ccache aarch64-w64-mingw32-c++
      ls -al
    popd
  echo "::endgroup::"
fi

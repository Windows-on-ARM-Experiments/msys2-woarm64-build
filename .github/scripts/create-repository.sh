#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

echo "::group::Create MSYS2 packages repository"
  mkdir -p repository/msys/x86_64
  mv -f mingw-w64-cross-*.pkg.* repository/msys/x86_64/
  pushd repository/msys/x86_64
    repo-add woarm64-cross.db.tar.gz *.pkg.*
  popd

  mkdir -p repository/mingw/aarch64
  mv -f mingw-w64-aarch64-*.pkg.* repository/mingw/aarch64/
  pushd repository/mingw/aarch64
    repo-add woarm64-native.db.tar.gz *.pkg.*
  popd
echo "::endgroup::"

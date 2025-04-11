#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

echo "::group::Create MSYS2 packages repository"
  mkdir -p repository/x86_64
  mv -f mingw-w64-cross-*.pkg.* repository/x86_64/
  pushd repository/x86_64
    repo-add woarm64.db.tar.gz *.pkg.*
  popd

  mkdir -p repository/aarch64
  mv -f mingw-w64-aarch64-*.pkg.* repository/aarch64/
  pushd repository/aarch64
    repo-add woarm64-native.db.tar.gz *.pkg.*
  popd
echo "::endgroup::"

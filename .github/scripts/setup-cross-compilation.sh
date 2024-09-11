#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

pushd /
  patch -p1 -i `cygpath "$GITHUB_WORKSPACE"`/patches/makepkg/0001-cross-compilation.patch
  cat /etc/makepkg_mingw.conf
  cat /etc/profile
  cat /usr/share/makepkg/tidy/strip.sh
popd

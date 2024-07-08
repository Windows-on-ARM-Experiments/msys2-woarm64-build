#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

DIR="`dirname ${BASH_SOURCE[0]}`/../.."
DIR=`realpath $DIR`
if [[ -n "$GITHUB_WORKSPACE" ]]; then
  echo "CCACHE_DIR=$DIR/ccache" >> "$GITHUB_ENV"
  echo timestamp=$(date -u --iso-8601=seconds) >> "$GITHUB_OUTPUT"
fi

pushd /
  echo "::group::/etc/makepkg.conf"
    patch -p1 -b -i "$DIR/patches/ccache/0001-makepkg.patch"
    cat /etc/makepkg.conf
  echo "::endgroup::"

  echo "::group::/etc/makepkg_mingw.conf"
    patch -p1 -b -i "$DIR/patches/ccache/0002-makepkg-mingw.patch"
    cat /etc/makepkg_mingw.conf
  echo "::endgroup::"
popd

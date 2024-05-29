#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

DIR="`dirname ${BASH_SOURCE[0]}`/../.."
DIR=`realpath $DIR`
CCACHE_DIR=$DIR/ccache
if [[ -n "$GITHUB_WORKSPACE" ]]; then
  echo "CCACHE_DIR=$CCACHE_DIR" >> "$GITHUB_ENV"
  echo timestamp=$(date -u --iso-8601=seconds) >> "$GITHUB_OUTPUT"
fi

mkdir -p $CCACHE_DIR

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

pacman -S --noconfirm ccache

pushd /usr/lib/ccache/bin
  echo "::group::Add aarch64 toolchain to ccache"
    export MSYS=winsymlinks
    ln -sf /usr/bin/ccache aarch64-w64-mingw32-c++
    ln -sf /usr/bin/ccache aarch64-w64-mingw32-g++
    ln -sf /usr/bin/ccache aarch64-w64-mingw32-gcc
    ln -sf /usr/bin/true makeinfo
  echo "::endgroup::"
popd

#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

PACKAGE_REPOSITORY=$1

DIR="`dirname ${BASH_SOURCE[0]}`/../.."
DIR=`realpath $DIR`
CCACHE_DIR=$DIR/ccache
if [[ -n "$GITHUB_WORKSPACE" ]]; then
  echo "CCACHE_DIR=$CCACHE_DIR" >> "$GITHUB_ENV"
  echo timestamp=$(date -u --iso-8601=seconds) >> "$GITHUB_OUTPUT"
fi

apply_patch () {
  if patch -R -p1 --dry-run -b -i "$1" > /dev/null 2>&1; then
    echo "Patch $1 is already applied"
  else
    patch -p1 -b -i "$1"
  fi
}

mkdir -p $CCACHE_DIR

pushd /
  echo "::group::/etc/makepkg.conf"
    apply_patch "$DIR/patches/ccache/0001-makepkg.patch"
    cat /etc/makepkg.conf
  echo "::endgroup::"

  echo "::group::/etc/makepkg_mingw.conf"
    apply_patch "$DIR/patches/ccache/0002-makepkg-mingw.patch"
    cat /etc/makepkg_mingw.conf
  echo "::endgroup::"
popd

if [[ "$PACKAGE_REPOSITORY" == *MINGW* ]]; then
  pacman -S --noconfirm mingw-w64-clang-aarch64-ccache
else
  pacman -S --noconfirm ccache
fi

pushd /usr/lib/ccache/bin
  echo "::group::Add aarch64 toolchain to ccache"
    export MSYS=winsymlinks
    ln -sf /usr/bin/ccache aarch64-w64-mingw32-c++
    ln -sf /usr/bin/ccache aarch64-w64-mingw32-g++
    ln -sf /usr/bin/ccache aarch64-w64-mingw32-gcc
  echo "::endgroup::"
popd

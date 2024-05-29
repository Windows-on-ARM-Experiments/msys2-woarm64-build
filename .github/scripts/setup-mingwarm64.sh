#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

if [ -z "$GITHUB_WORKSPACE" ]; then
  DIR=`pwd`
else
  DIR=`cygpath "$GITHUB_WORKSPACE"`
fi

echo "::group::Install patch"
  pacman -S --noconfirm patch
echo "::endgroup::"

pushd /
  echo "::group::Patch MSYS2 environment"
    patch -p1 -b -i "$DIR/patches/makepkg/0001-mingwarm64.patch"
    if [[ "$CROSS_BUILD" = "1" ]]; then
      patch -p1 -b -i "$DIR/patches/makepkg/0002-mingwarm64-cross-build.patch"
    fi
    if [[ "$DEBUG_BUILD" = "1" ]]; then
      patch -p1 -b -i "$DIR/patches/makepkg/0003-enable-debug.patch"
    fi
  echo "::endgroup::"

  echo "::group::/etc/makepkg_mingw.conf"
    cat /etc/makepkg_mingw.conf
  echo "::endgroup::"

  echo "::group::/etc/profile"
    cat /etc/profile
  echo "::endgroup::"

  echo "::group::/usr/share/makepkg/tidy/strip.sh"
    cat /usr/share/makepkg/tidy/strip.sh
  echo "::endgroup::"
popd

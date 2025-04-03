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
    patch -p1 -b -i "$DIR/patches/makepkg/0004-add-recheck-option.patch"
  echo "::endgroup::"
popd

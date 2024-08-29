#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

DIR="`dirname ${BASH_SOURCE[0]}`/../.."
DIR=`realpath $DIR`

echo "::group::Install patch"
  pacman -S --noconfirm patch
echo "::endgroup::"

pushd /
  echo "::group::Patch Dejagnu"
    patch -p1 -b -i "$DIR/patches/dejagnu/0001-local-exec.patch"
  echo "::endgroup::"
popd

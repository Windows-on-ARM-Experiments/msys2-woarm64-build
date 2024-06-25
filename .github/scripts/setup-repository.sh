#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

if [ -z "$GITHUB_WORKSPACE" ]; then
  DIR=`pwd`
else
  DIR=`cygpath "$GITHUB_WORKSPACE"`
fi

pushd /
  echo "::group::Install patch"
    pacman -S --noconfirm patch
  echo "::endgroup::"

  echo "::group::Add WoArm64 repository"
    patch -p1 -b -i "$DIR/patches/pacman/0002-add-woarm64-repository.patch"
  echo "::endgroup::"

  echo "::group::Update packages database"
    pacman -Sy --noconfirm
  echo "::endgroup::"
popd

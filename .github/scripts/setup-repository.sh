#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

DIR="`dirname ${BASH_SOURCE[0]}`/../.."
DIR=`realpath $DIR`

apply_patch () {
  if patch -R -p1 --dry-run -b -i "$1" > /dev/null 2>&1; then
    echo "Patch $1 is already applied"
  else
    patch -p1 -b -i "$1"
  fi
}

echo "::group::Install patch"
  pacman -S --noconfirm patch
echo "::endgroup::"

pushd /
  echo "::group::Add WoArm64 repository"
    if [[ "$FLAVOR" = "NATIVE_WITH_NATIVE" ]]; then
      apply_patch "$DIR/patches/pacman/0002-add-woarm64-native-repository.patch"
    else
      apply_patch "$DIR/patches/pacman/0001-add-woarm64-cross-repository.patch"
    fi
  echo "::endgroup::"

  echo "::group::Update packages database"
    pacman -Sy --noconfirm
  echo "::endgroup::"
popd

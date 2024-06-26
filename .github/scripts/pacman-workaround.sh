#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

if [ -z "$GITHUB_WORKSPACE" ]; then
  DIR=`pwd`
else
  DIR=`cygpath "$GITHUB_WORKSPACE"`
fi

echo "::group::Pacman hang workaround"
  while ! timeout -k 15s 10s pacman -U --noconfirm "$DIR/patches/pacman/pacman-6.1.0-4-x86_64.pkg.tar.zst"
  do
    echo "Command failed, retrying..."
  done
echo "::endgroup::"

echo "::group::Install patch"
  pacman -S --noconfirm patch
echo "::endgroup::"

pushd /
  echo "::group::Pin pacman packages"
    patch -p1 -b -i "$DIR/patches/pacman/0001-pin-pacman.patch"
  echo "::endgroup::"

  echo "::group::/etc/pacman.conf"
    cat /etc/pacman.conf
  echo "::endgroup::"
popd

echo "::group::Update packages"
  pacman -Syuu --noconfirm
echo "::endgroup::"

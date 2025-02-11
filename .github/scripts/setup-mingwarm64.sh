#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

if [ -z "$GITHUB_WORKSPACE" ]; then
  DIR=`pwd`
else
  DIR=`cygpath "$GITHUB_WORKSPACE"`
fi

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
  echo "::group::Patch MSYS2 environment"
    apply_patch "$DIR/patches/makepkg/0001-mingwarm64.patch"
    if [[ "$FLAVOR" != "NATIVE_WITH_NATIVE" ]]; then
      apply_patch "$DIR/patches/makepkg/0002-mingwarm64-cross-build.patch"
    fi
    if [[ "$DEBUG_BUILD" = "1" ]]; then
      apply_patch "$DIR/patches/makepkg/0003-enable-debug.patch"
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

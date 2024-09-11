#!/bin/bash

set -e # exit on error
set -x # echo on

CLEAN_BUILD=${CLEAN_BUILD:-0}

MAKEPKG_OPTIONS="--syncdeps --rmdeps --noconfirm --noprogressbar --nocheck --force --install"
if [ "$CLEAN_BUILD" = 1 ] ; then
  MAKEPKG_OPTIONS="$MAKEPKG_OPTIONS --cleanbuild"
fi

pacman -R --noconfirm mingw-w64-cross-mingwarm64-zlib || true
pacman -R --noconfirm mingw-w64-cross-mingwarm64-gcc || true
pacman -R --noconfirm mingw-w64-cross-mingwarm64-winpthreads || true
pacman -R --noconfirm mingw-w64-cross-mingwarm64-crt || true
pacman -R --noconfirm mingw-w64-cross-mingwarm64-windows-default-manifest || true
pacman -R --noconfirm mingw-w64-cross-mingwarm64-gcc-stage1 || true
pacman -R --noconfirm mingw-w64-cross-mingwarm64-binutils || true
pacman -R --noconfirm mingw-w64-cross-mingwarm64-headers || true

pacman -S --noconfirm base-devel

echo "::group::Build mingw-w64-cross-mingwarm64-headers"
  pushd ../MSYS2-packages/mingw-w64-cross-mingwarm64-headers
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-mingwarm64-binutils"
  pushd ../MSYS2-packages/mingw-w64-cross-mingwarm64-binutils
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-mingwarm64-gcc-stage1"
  pushd ../MSYS2-packages/mingw-w64-cross-mingwarm64-gcc-stage1
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-mingwarm64-windows-default-manifest"
  pushd ../MSYS2-packages/mingw-w64-cross-mingwarm64-windows-default-manifest
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-mingwarm64-crt"
  .github/scripts/pthread-headers-hack-before.sh
  pushd ../MSYS2-packages/mingw-w64-cross-mingwarm64-crt
    makepkg $MAKEPKG_OPTIONS
  popd
  .github/scripts/pthread-headers-hack-after.sh
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-mingwarm64-winpthreads"
  pushd ../MSYS2-packages/mingw-w64-cross-mingwarm64-winpthreads
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-mingwarm64-gcc"
  pushd ../MSYS2-packages/mingw-w64-cross-mingwarm64-gcc
    makepkg ${MAKEPKG_OPTIONS//--install/}
    pacman -R --noconfirm mingw-w64-cross-mingwarm64-gcc-stage1 || true
    pacman -U --noconfirm *.pkg.tar.zst
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-mingwarm64-zlib"
  pushd ../MSYS2-packages/mingw-w64-cross-mingwarm64-zlib
    makepkg $MAKEPKG_OPTIONS --skippgpcheck
  popd
echo "::endgroup::"

#!/bin/bash

set -e # exit on error
set -x # echo on

CLEAN_BUILD=${CLEAN_BUILD:-0}

MAKEPKG_OPTIONS="--syncdeps --rmdeps --noconfirm --noprogressbar --nocheck --force --install"
if [ "$CLEAN_BUILD" = 1 ] ; then
  MAKEPKG_OPTIONS="$MAKEPKG_OPTIONS --cleanbuild"
fi

pacman -R --noconfirm mingw-w64-cross-gcc || true
pacman -R --noconfirm mingw-w64-cross-winpthreads || true
pacman -R --noconfirm mingw-w64-cross-crt || true
pacman -R --noconfirm mingw-w64-cross-windows-default-manifest || true
pacman -R --noconfirm mingw-w64-cross-gcc-stage1 || true
pacman -R --noconfirm mingw-w64-cross-binutils || true
pacman -R --noconfirm mingw-w64-cross-headers || true

pacman -S --noconfirm base-devel

echo "::group::Build mingw-w64-cross-headers"
  pushd ../MSYS2-packages/mingw-w64-cross-headers
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-binutils"
  pushd ../MSYS2-packages/mingw-w64-cross-binutils
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-gcc-stage1"
  pushd ../MSYS2-packages/mingw-w64-cross-gcc-stage1
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-windows-default-manifest"
  pushd ../MSYS2-packages/mingw-w64-cross-windows-default-manifest
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-crt"
  .github/scripts/pthread-headers-hack-before.sh
  pushd ../MSYS2-packages/mingw-w64-cross-crt
    makepkg $MAKEPKG_OPTIONS
  popd
  .github/scripts/pthread-headers-hack-after.sh
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-winpthreads"
  pushd ../MSYS2-packages/mingw-w64-cross-winpthreads
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-gcc"
  pushd ../MSYS2-packages/mingw-w64-cross-gcc
    makepkg ${MAKEPKG_OPTIONS//--install/}
    pacman -R --noconfirm mingw-w64-cross-gcc-stage1 || true
    pacman -U --noconfirm *.pkg.tar.zst
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-zlib"
  pushd ../MSYS2-packages/mingw-w64-cross-zlib
    makepkg $MAKEPKG_OPTIONS --skippgpcheck
  popd
echo "::endgroup::"

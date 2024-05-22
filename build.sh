#!/bin/bash

set -e # exit on error
set -x # echo on

CLEAN_BUILD=${CLEAN_BUILD:-0}

MAKEPKG_OPTIONS="--syncdeps --rmdeps --noconfirm --noprogressbar --nocheck --force --install"
if [ "$CLEAN_BUILD" = 1 ] ; then
  MAKEPKG_OPTIONS="$MAKEPKG_OPTIONS --cleanbuild"
fi

pacman -R mingw-w64-cross-gcc --noconfirm || true
pacman -R mingw-w64-cross-winpthreads --noconfirm || true
pacman -R mingw-w64-cross-crt --noconfirm || true
pacman -R mingw-w64-cross-windows-default-manifest --noconfirm || true
pacman -R mingw-w64-cross-gcc-stage1 --noconfirm || true
pacman -R mingw-w64-cross-binutils --noconfirm || true
pacman -R mingw-w64-cross-headers --noconfirm || true

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
  pushd ../MSYS2-packages/mingw-w64-cross-crt
    pacman -S --noconfirm mingw-w64-cross-winpthreads
    cp /opt/x86_64-w64-mingw32/include/pthread_signal.h /opt/aarch64-w64-mingw32/include/
    cp /opt/x86_64-w64-mingw32/include/pthread_unistd.h /opt/aarch64-w64-mingw32/include/
    cp /opt/x86_64-w64-mingw32/include/pthread_time.h /opt/aarch64-w64-mingw32/include/

    makepkg $MAKEPKG_OPTIONS

    rm -rf /opt/aarch64-w64-mingw32/include/pthread_signal.h
    rm -rf /opt/aarch64-w64-mingw32/include/pthread_unistd.h
    rm -rf /opt/aarch64-w64-mingw32/include/pthread_time.h
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-winpthreads"
  pushd ../MSYS2-packages/mingw-w64-cross-winpthreads
    makepkg $MAKEPKG_OPTIONS
  popd
echo "::endgroup::"

echo "::group::Build mingw-w64-cross-gcc"
  pushd ../MSYS2-packages/mingw-w64-cross-gcc
    makepkg ${MAKEPKG_OPTIONS//--install/}
    pacman -R mingw-w64-cross-gcc-stage1 --noconfirm || true
    pacman -U *.pkg.tar.zst --noconfirm
  popd
echo "::endgroup::"

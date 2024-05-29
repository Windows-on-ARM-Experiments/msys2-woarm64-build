#!/bin/bash

set -e # exit on error
set -x # echo on

for ARCH in "aarch64" "x86_64"; do
  PACKAGES="mingw-w64-$ARCH-gcc \
    mingw-w64-$ARCH-windows-default-manifest \
    mingw-w64-$ARCH-binutils \
    mingw-w64-$ARCH-libwinpthread-git
    mingw-w64-$ARCH-winpthreads-git \
    mingw-w64-$ARCH-crt-git \
    mingw-w64-$ARCH-headers-git \
    mingw-w64-$ARCH-mpc \
    mingw-w64-$ARCH-isl \
    mingw-w64-$ARCH-mpfr \
    mingw-w64-$ARCH-gmp \
    mingw-w64-$ARCH-zstd \
    mingw-w64-$ARCH-zlib \
    mingw-w64-$ARCH-bzip2 \
    mingw-w64-$ARCH-gettext \
    mingw-w64-$ARCH-ncurses \
    mingw-w64-$ARCH-libsystre \
    mingw-w64-$ARCH-libtre-git \
    mingw-w64-$ARCH-libiconv"

  for PACKAGE in $PACKAGES; do
    pacman -R --noconfirm --cascade $PACKAGE || true
  done
done

#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

for ENV in "common" "mingw32" "mingw64" "ucrt64" "mingwarm64"; do
  PACKAGES=" \
    mingw-w64-cross-$ENV-zlib \
    mingw-w64-cross-$ENV-gcc \
    mingw-w64-cross-$ENV-winpthreads \
    mingw-w64-cross-$ENV-crt \
    mingw-w64-cross-$ENV-windows-default-manifest \
    mingw-w64-cross-$ENV-gcc-stage1 \
    mingw-w64-cross-$ENV-binutils \
    mingw-w64-cross-$ENV-headers"

  for PACKAGE in $PACKAGES; do
    pacman -R --noconfirm --cascade $PACKAGE || true
  done
done
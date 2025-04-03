#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

DEPENDENCIES=$1

case $FLAVOR in
  "CROSS")
    pacman -S --noconfirm \
      git \
      base-devel \
      $DEPENDENCIES
    ;;
  "NATIVE_WITH_CROSS")
    pacman -S --noconfirm \
      git \
      base-devel \
      mingw-w64-cross-mingwarm64-gcc \
      mingw-w64-cross-mingwarm64-windows-default-manifest \
      mingw-w64-x86_64-gcc-libs \
      $DEPENDENCIES
    ;;
  "NATIVE_WITH_NATIVE")
    pacman -S --noconfirm \
      git \
      base-devel \
      mingw-w64-aarch64-gcc \
      $DEPENDENCIES
    ;;
  *)
    echo "Unknown flavor: $FLAVOR"
    exit 1
    ;;
esac

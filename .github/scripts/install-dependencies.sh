#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

DEPENDENCIES=" \
    git \
    base-devel \
    $1"

case $FLAVOR in
  "NATIVE_WITH_CROSS")
    DEPENDENCIES=" \
      mingw-w64-cross-mingwarm64-gcc \
      mingw-w64-cross-mingwarm64-windows-default-manifest \
      mingw-w64-x86_64-gcc-libs \
      $DEPENDENCIES"
    ;;
  "NATIVE_WITH_NATIVE")
    DEPENDENCIES=" \
      mingw-w64-aarch64-gcc \
      $DEPENDENCIES"
    ;;
esac

if [ "$NO_CHECK" = 0 ]; then
    DEPENDENCIES="$DEPENDENCIES \
      dejagnu"
fi

pacman -S --noconfirm $DEPENDENCIES

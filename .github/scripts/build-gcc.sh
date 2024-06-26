#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

if [ -z "$GITHUB_WORKSPACE" ]; then
  DIR=`pwd`
else
  DIR=`cygpath "$GITHUB_WORKSPACE"`
fi

SRC_DIR=$DIR/gcc
BUILD_DIR=$DIR/gcc-build
INSTALL_DIR=$DIR/gcc-install

BUILD=x86_64-pc-msys
TARGET=x86_64-w64-mingw32
CC=gcc
CXX=g++
PATH="/usr/lib/ccache/bin:/opt/$TARGET/bin:/opt/$BUILD/bin:$PATH"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
mkdir -p $INSTALL_DIR

pushd $BUILD_DIR
    # Compared to https://github.com/msys2/MINGW-packages/blob/master/mingw-w64-gcc/PKGBUILD
    # --with-local-prefix=$INSTALL_DIR/local \
    # --libexecdir=$INSTALL_DIR/lib \
    # --with-native-system-header-dir=$INSTALL_DIR/include \
    #   REMOVED: --enable-languages=c++,ada,objc,rust,jit
    #   REMOVED: --enable-libstdcxx-filesystem-ts
    #   REMOVED: --enable-libstdcxx-time
    #   REMOVED: --disable-libstdcxx-pch
    #   REMOVED: --with-boot-ldflags="-static-libstdc++"
    #   REMOVED: --with-stage1-ldflags="-static-libstdc++"
    #   REMOVED: --with-{gmp,mpfr,mpc,isl}=$INSTALL_DIR
    #   REMOVED: --with-arch=nocona
    #   REMOVED: --with-tune=generic
    #   CHANGED: --enable-lto to --disable-lto
    #   CHANGED: --enable-plugin to --disable-plugin
    #   ADDED: --enable-maintainer-mode
    #   ADDED: --disable-libstdcxx
    #   ADDED: --disable-libgomp
    $SRC_DIR/configure \
        --prefix=$INSTALL_DIR \
        --build=$BUILD \
        --host=$TARGET \
        --target=$TARGET \
        --enable-shared \
        --enable-static \
        --enable-bootstrap \
        --enable-maintainer-mode \
        --enable-languages=c,lto,fortran \
        --enable-threads=win32 \
        --enable-checking=release \
        --enable-libatomic \
        --enable-graphite \
        --enable-libgomp \
        --enable-fully-dynamic-string \
        --disable-libstdcxx \
        --disable-libgomp \
        --disable-libssp \
        --disable-multilib \
        --disable-lto \
        --disable-plugin \
        --disable-rpath \
        --disable-win32-registry \
        --disable-nls \
        --disable-werror \
        --disable-symvers \
        --with-libiconv \
        --with-system-zlib \
        --with-gnu-as \
        --with-gnu-ld \
        CC=$CC \
        CXX=$CXX

    ccache -svv || true
      make V=1 -j$(nproc)
    ccache -svv || true

    make install
popd

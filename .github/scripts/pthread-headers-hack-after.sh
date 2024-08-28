#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

pacman -R --noconfirm mingw-w64-cross-mingw64-winpthreads || true
rm -rf /opt/aarch64-w64-mingw32/include/pthread_signal.h
rm -rf /opt/aarch64-w64-mingw32/include/pthread_unistd.h
rm -rf /opt/aarch64-w64-mingw32/include/pthread_time.h

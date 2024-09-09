#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

pacman -S --noconfirm mingw-w64-cross-mingw64-winpthreads
cp /opt/x86_64-w64-mingw32/include/pthread_signal.h /opt/aarch64-w64-mingw32/include/
cp /opt/x86_64-w64-mingw32/include/pthread_unistd.h /opt/aarch64-w64-mingw32/include/
cp /opt/x86_64-w64-mingw32/include/pthread_time.h /opt/aarch64-w64-mingw32/include/

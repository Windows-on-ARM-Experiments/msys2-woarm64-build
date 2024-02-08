#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

pacman -Syu --noconfirm

# Add WoArm64 custom repository.
REPO='[woarm64]
Server = https://windows-on-arm-experiments.github.io/msys2-woarm64-build/x86_64
SigLevel = Optional

'
echo -e "$REPO$(cat /etc/pacman.conf)" > /etc/pacman.conf

pacman -Sy --noconfirm
pacman -S mingw-w64-cross-gcc --noconfirm

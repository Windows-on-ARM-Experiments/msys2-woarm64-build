#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

if [[ $(ls *.pkg.tar.zst 2>/dev/null) != "" ]]; then
    pacman -U --noconfirm *.pkg.tar.zst
else
    echo "No package file found. Skipping installation."
fi

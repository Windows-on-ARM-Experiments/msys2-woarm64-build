#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

pacman -U --noconfirm *.pkg.tar.zst

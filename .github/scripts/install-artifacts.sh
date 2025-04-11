#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../../config.sh

pacman -U --noconfirm *.pkg.tar.zst

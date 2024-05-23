#!/bin/bash

set -e # exit on error
set -x # echo on

sed -i 's/\(BUILDENV=(.*\)!ccache\(.*\)/\1ccache\2/g' /etc/makepkg.conf
cat /etc/makepkg.conf

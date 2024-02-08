#!/bin/bash

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

# Sanity check of the GCC binary and its version.
aarch64-w64-mingw32-gcc --version

# Create a simple "Hello, World!" program binary.
echo '#include <stdio.h>
int main() {
  printf("Hello, World!\n");
  return 0;
}
' > hello-world.c
aarch64-w64-mingw32-gcc -o hello-world.exe hello-world.c

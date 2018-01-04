#!/bin/bash
# Compile script for NinjaVM
# Expects to be above the source folder.
# Creates one file called njvm in folder out

clear
if [ ! -d "out" ]; then
    mkdir out
fi
cd src
gcc -g -std=c89 -Wall -pedantic -o ../out/njvm debugger.c heap.c instructions.c njvm.c sda.c stack.c support.c -L ../lib/ -l bigint
cd ../out
chmod +x njvm

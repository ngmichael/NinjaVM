#!/bin/bash
# Compile script for NinjaVM
# Expects to be above the source folder.
# Creates one file called njvm in folder out

if [ ! -d "out" ]; then
    mkdir out
fi
cd src
gcc -g -std=c89 -Wall -pedantic -o ../out/njvm njvm.c stack.c sda.c instructions.c debugger.c utils.c
cd ../out
chmod +x njvm

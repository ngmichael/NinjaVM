#!/bin/bash
# Archive building script for NinjaVM
# Expects to be above the source folder.
# Generates an archive with sources, documentation and a compile script

rm -rf out/ngmh83
mkdir out/ngmh83
cp src out/ngmh83/src -r
cp docs/DebuggerDocumentation.txt out/ngmh83/debug.txt
cp docs/ExitCodes.txt out/ngmh83/ExitCodes.txt
echo "Michael, Noah George, 5090989
Muenscher, Felix, 5096954" >> out/ngmh83/KSP-HU1.TEAM
echo "cd src
gcc -g -std=c89 -Wall -pedantic -o ../njvm njvm.c stack.c sda.c instructions.c debugger.c utils.c
cd ..
chmod +x njvm" >> out/ngmh83/mknjvm
chmod +x out/ngmh83/mknjvm
cd out
tar -cvf ngmh83.tar ngmh83
gzip ngmh83.tar

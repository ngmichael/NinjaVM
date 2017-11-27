#!/bin/bash
# Archive building script for NinjaVM
# Expects to be above the source folder.
# Generates an archive with sources, documentation and a compile script

# Remove out folder and its content, if it exists
if [ -d "out" ]; then
    rm -r out
fi

# Generate folder structure
mkdir out
mkdir out/ngmh83

# Copy source files
cp src out/ngmh83/src -r

# Copy and rename debugger documentation
cp docs/DebuggerDocumentation.txt out/ngmh83/debug.txt

# Generate readme.txt
cp docs/ExitCodes.txt out/ngmh83/ExitCodes.txt

# Generate KSP-HU1.TEAM file
echo "Michael, Noah George, 5090989
Muenscher, Felix, 5096954" > out/ngmh83/KSP-HU1.TEAM

# Generate NinjaVM compile script and make it executable
echo "cd src
gcc -g -std=c89 -Wall -pedantic -o ../njvm njvm.c stack.c sda.c instructions.c debugger.c utils.c
cd ..
chmod +x njvm" > out/ngmh83/mknjvm
chmod +x out/ngmh83/mknjvm

# Build the archive
cd out
tar -cvf ngmh83.tar ngmh83
gzip ngmh83.tar

# Cleanup all temporary file
rm ngmh83 -r

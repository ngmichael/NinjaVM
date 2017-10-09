cmake_minimum_required(VERSION 3.8)
project(ksp_ws17-18)

set(CMAKE_C_STANDARD 99)

set(SOURCE_FILES src/njvm.c src/njvm.c src/headers/njvm.h)
add_executable(NinjaVM ${SOURCE_FILES})
#!/usr/bin/env bash

set -ex

arg_passed=$1
cmake_arg_passed=""
if [ "$arg_passed" == "release" ]; then
    cmake_arg_passed=Release
elif [ "$arg_passed" == "debug" ]; then
    cmake_arg_passed=Debug
else
    echo "Wrong argument: '$arg_passed'. Expected either 'debug' or 'release'"
    false
fi

MY_ZIGLANG_SRC_DIR=$HOME/dev/zig
MY_ZIG_BUILD_DIR=build-$arg_passed

git clone https://github.com/ziglang/zig $MY_ZIGLANG_SRC_DIR || true
cd $MY_ZIGLANG_SRC_DIR
mkdir $MY_ZIG_BUILD_DIR
return_value=$?
cd $MY_ZIG_BUILD_DIR

if [ $return_value -eq 0 ]; then
    cmake .. -DCMAKE_BUILD_TYPE=$cmake_arg_passed -DCMAKE_PREFIX_PATH="$HOME/programs/llvm17-release" -DZIG_NO_LIB=ON -DZIG_NO_LANGREF=ON
else
    touch ../CMakeLists.txt
fi

ninja install

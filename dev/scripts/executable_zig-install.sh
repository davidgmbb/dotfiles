#!/usr/bin/env bash

set -ex

if [ "$#" -ne 1 ]; then
    printf 'Usage: %s debug|release\n' "$0" >&2
    exit 1
fi

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

MY_ZIGLANG_SRC_DIR="$HOME/dev/zig"
MY_ZIG_BUILD_DIR="$MY_ZIGLANG_SRC_DIR/build-$arg_passed"
MY_ZIG_LLVM_PREFIX="${LLVM_PREFIX_PATH:-$HOME/programs/llvm17-release}"

if [ ! -d "$MY_ZIGLANG_SRC_DIR/.git" ]; then
    mkdir -p -- "$HOME/dev"
    git clone https://github.com/ziglang/zig "$MY_ZIGLANG_SRC_DIR"
fi

cmake -S "$MY_ZIGLANG_SRC_DIR" -B "$MY_ZIG_BUILD_DIR" -G Ninja \
    "-DCMAKE_BUILD_TYPE=$cmake_arg_passed" \
    "-DCMAKE_PREFIX_PATH=$MY_ZIG_LLVM_PREFIX" \
    -DZIG_NO_LIB=ON -DZIG_NO_LANGREF=ON
cmake --build "$MY_ZIG_BUILD_DIR" --target install

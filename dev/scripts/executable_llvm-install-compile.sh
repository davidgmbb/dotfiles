#!/bin/bash
set -ex

if [ "$#" -ne 1 ]; then
    echo 'You must pass a optimization option'
    exit 1
fi

MY_OPTIMIZATION_MODE=$1
MY_LLVM_ASSERTIONS=""
MY_CMAKE_OPTIMIZATION_MODE=""

if [ "$MY_OPTIMIZATION_MODE" = "debug" ]; then
    MY_CMAKE_OPTIMIZATION_MODE="Debug"
    MY_LLVM_ASSERTIONS="ON"
elif [ "$MY_OPTIMIZATION_MODE" = "release" ]; then
    MY_CMAKE_OPTIMIZATION_MODE="Release"
    MY_LLVM_ASSERTIONS="OFF"
else
    echo "Invalid optimization mode: '$MY_OPTIMIZATION_MODE'"
    exit 1
fi

. "$HOME/dev/scripts/llvm-common.sh"
MY_LLVM_SOURCE_DIR="$HOME/source/llvm-project-$MY_LLVM_VERSION"
MY_LLVM_BUILD_DIR="$MY_LLVM_SOURCE_DIR/build-$MY_OPTIMIZATION_MODE"

if [ ! -d "$MY_LLVM_SOURCE_DIR/.git" ]; then
    mkdir -p -- "$HOME/source"
    git clone --depth 1 --branch "release/$MY_LLVM_VERSION.x" https://github.com/llvm/llvm-project "$MY_LLVM_SOURCE_DIR"
fi
git -C "$MY_LLVM_SOURCE_DIR" checkout "release/$MY_LLVM_VERSION.x"

cmake -S "$MY_LLVM_SOURCE_DIR/llvm" -B "$MY_LLVM_BUILD_DIR" \
  "-DCMAKE_INSTALL_PREFIX=$HOME/programs/llvm$MY_LLVM_VERSION-$MY_OPTIMIZATION_MODE" \
  "-DCMAKE_BUILD_TYPE=$MY_CMAKE_OPTIMIZATION_MODE" \
  -DLLVM_ENABLE_PROJECTS="lld;clang" \
  -DLLVM_ENABLE_LIBXML2=OFF \
  -DLLVM_ENABLE_TERMINFO=OFF \
  -DLLVM_ENABLE_LIBEDIT=OFF \
  "-DLLVM_ENABLE_ASSERTIONS=$MY_LLVM_ASSERTIONS" \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -G Ninja
cmake --build "$MY_LLVM_BUILD_DIR" --target install

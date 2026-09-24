#!/usr/bin/env bash
set -e

echo "Windows Game Emulator native runtime preparation"
echo "Target: Android ARM64"
echo
echo "Box64 supports Android builds and Wine integration."
echo "This script prepares the source tree; native Android packaging"
echo "must be performed with an Android NDK toolchain."

if [ ! -d box64 ]; then
  git clone --depth 1 https://github.com/ptitSeb/box64.git
fi

cd box64
mkdir -p build
cd build

cmake .. \
  -DANDROID=ON \
  -DARM64=ON \
  -DBAD_SIGNAL=ON \
  -DCMAKE_BUILD_TYPE=Release

cmake --build . --config Release -j2

echo
echo "Box64 build finished. The resulting binary still needs to be"
echo "packaged with a compatible Wine runtime/root filesystem."

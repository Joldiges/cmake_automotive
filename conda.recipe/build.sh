#!/usr/bin/env bash
set -euo pipefail

cmake -S . -B automotive-build -G Ninja ${CMAKE_ARGS:-} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_USE_SYSTEM_LIBRARIES=OFF \
  -DCMAKE_USE_OPENSSL=ON \
  -DOPENSSL_ROOT_DIR="$PREFIX" \
  -DBUILD_CursesDialog=OFF \
  -DBUILD_QtDialog=OFF \
  -DBUILD_TESTING=ON
cmake --build automotive-build --parallel "${CPU_COUNT:-2}"
./automotive-build/bin/ctest --test-dir automotive-build \
  -R '^RunCMake.DiabCompilerId$' --output-on-failure
cmake --install automotive-build

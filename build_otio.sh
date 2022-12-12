#!/usr/bin/env bash

set -ex

git clone --depth 1 --branch "$OTIO_VERSION" https://github.com/PixarAnimationStudios/OpenTimelineIO.git
cd OpenTimelineIO

# (A), (B), (C): Comment out below line
# (D), (E): Uncomment below line
#patch -u ./tests/CMakeLists.txt /tmp/FixTestsIncludeDir.patch

mkdir build
cd build

# (A):
cmake .. -G "Ninja" \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_STANDARD="17" \
  -DCMAKE_INSTALL_PREFIX="${OLIVE_INSTALL_PREFIX}" \
  -DOTIO_PYTHON_INSTALL=OFF

# (B):
#cmake .. -G "Ninja" \
#  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
#  -DCMAKE_CXX_STANDARD="17" \
#  -DCMAKE_INSTALL_PREFIX="${OLIVE_INSTALL_PREFIX}" \
#  -DOTIO_PYTHON_INSTALL=OFF \
#  -DOTIO_IMATH_LIBS="${OLIVE_INSTALL_PREFIX}/lib64/libImath-3_1.so.29.4.0"

# (C), (D):
#cmake .. -G "Ninja" \
#  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
#  -DCMAKE_CXX_STANDARD="17" \
#  -DCMAKE_INSTALL_PREFIX="${OLIVE_INSTALL_PREFIX}" \
#  -DOTIO_PYTHON_INSTALL=OFF \
#  -DOTIO_IMATH_LIBS="${OLIVE_INSTALL_PREFIX}/lib64/libImath-3_1.so.29.4.0" \
#  -DIMATH_INCLUDES="${OLIVE_INSTALL_PREFIX}/include/Imath"

# (E):
#cmake .. -G "Ninja" \
#  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
#  -DCMAKE_CXX_STANDARD="17" \
#  -DCMAKE_INSTALL_PREFIX="${OLIVE_INSTALL_PREFIX}" \
#  -DOTIO_PYTHON_INSTALL=OFF \
#  -DOTIO_FIND_IMATH=ON

cmake --build .
cmake --install .

cd ../..
rm -rf OpenTimelineIO

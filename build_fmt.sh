#!/bin/bash

set -exo pipefail

# install/build prefix common to all libs
LIB_INSTALL_PREFIX=${LIB_INSTALL_PREFIX:-/usr/local}
LIB_BUILD_PREFIX=${LIB_BUILD_PREFIX:-/tmp}

LIB_FMT_VERSION=10.1.1
LIB_FMT_INSTALL_PREFIX=${LIB_FMT_INSTALL_PREFIX:-${LIB_INSTALL_PREFIX}}
LIB_FMT_BUILD_PREFIX=${LIB_FMT_BUILD_PREFIX:-${LIB_BUILD_PREFIX}}

cd "${LIB_FMT_BUILD_PREFIX}"
if [ ! -d fmt ]; then
    HOME=/dev/null git clone https://github.com/fmtlib/fmt.git
fi

cd fmt
git checkout "${LIB_FMT_VERSION}"

function build() {
    echo "Building fmt target=${1}"

    rm -rf build
    mkdir build
    cd build
    cmake -DFMT_TEST=OFF -DCMAKE_BUILD_TYPE=${1} -DCMAKE_INSTALL_PREFIX=${LIB_FMT_INSTALL_PREFIX} ../
    make -j 20
    make install
    cd ../
}

build Debug
mv ${LIB_FMT_INSTALL_PREFIX}/lib/libfmtd.a ${LIB_FMT_INSTALL_PREFIX}/lib/libfmt-debug.a 

build Release
mv ${LIB_FMT_INSTALL_PREFIX}/lib/libfmt.a ${LIB_FMT_INSTALL_PREFIX}/lib/libfmt-release.a 

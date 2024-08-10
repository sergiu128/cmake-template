#!/bin/bash

set -exo pipefail

# install/build prefix common to all libs
LIB_INSTALL_PREFIX=${LIB_INSTALL_PREFIX:-/usr/local}
LIB_BUILD_PREFIX=${LIB_BUILD_PREFIX:-/tmp}

LIB_TEST_VERSION="1.14.0"
LIB_BENCHMARK_VERSION="1.8.3"
LIB_TEST_BENCHMARK_INSTALL_PREFIX=${LIB_TEST_BENCHMARK_INSTALL_PREFIX:-${LIB_INSTALL_PREFIX}}
LIB_TEST_BENCHMARK_BUILD_PREFIX=${LIB_TEST_BENCHMARK_BUILD_PREFIX:-${LIB_BUILD_PREFIX}}

cd "${LIB_TEST_BENCHMARK_BUILD_PREFIX}"
if [ ! -d benchmark ]; then
    HOME=/dev/null git clone https://github.com/google/benchmark.git
fi

cd benchmark
git checkout "v${LIB_BENCHMARK_VERSION}"

# we use the googletest submodule from benchmark
cd "${LIB_TEST_BENCHMARK_BUILD_PREFIX}/benchmark"
if [ ! -d googletest ]; then
    HOME=/dev/null git clone https://github.com/google/googletest.git
fi

cd googletest
git checkout "v${LIB_TEST_VERSION}"

function build_benchmark() {
    echo "Building google_benchmark build_type=${1}."

    cd "${LIB_TEST_BENCHMARK_BUILD_PREFIX}/benchmark"
    rm -rf build
    mkdir -p build
    cmake -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC} \
        -DCMAKE_CXX_STANDARD=20 -DCMAKE_CXX_STANDARD_REQUIRED=ON \
        -DCMAKE_INSTALL_PREFIX=${LIB_TEST_BENCHMARK_INSTALL_PREFIX} \
        -DCMAKE_BUILD_TYPE="${1}" \
        -DBENCHMARK_ENABLE_GTEST_TESTS=ON \
        -DBENCHMARK_DOWNLOAD_DEPENDENCIES=OFF \
        -S . -B "build"
            cmake --build "build" --config ${1} --target install -- -j 20
        }

        function build_test() {
            echo "Building google_test target=${1}."

            cd "${LIB_TEST_BENCHMARK_BUILD_PREFIX}/benchmark/googletest"
            rm -rf build
            mkdir -p build
            cmake -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC} \
                -DCMAKE_CXX_STANDARD=20 -DCMAKE_CXX_STANDARD_REQUIRED=ON \
                -DCMAKE_INSTALL_PREFIX=${LIB_TEST_BENCHMARK_INSTALL_PREFIX} \
                -DCMAKE_BUILD_TYPE="${1}"\
                -S . -B "build"
                            cmake --build "build" --config ${1} --target install -- -j 20
                        }

                        build_benchmark Debug
                        build_test Debug
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libbenchmark.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libbenchmark-debug.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libbenchmark_main.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libbenchmark_main-debug.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgmock.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgmock-debug.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgmock_main.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgmock_main-debug.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgtest.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgtest-debug.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgtest_main.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgtest_main-debug.a

                        build_benchmark Release
                        build_test Release
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libbenchmark.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libbenchmark-release.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libbenchmark_main.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libbenchmark_main-release.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgmock.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgmock-release.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgmock_main.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgmock_main-release.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgtest.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgtest-release.a
                        mv ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgtest_main.a ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib/libgtest_main-release.a

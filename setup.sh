#!/bin/bash

echo "Setting up..."

for program in cmake clang ninja clang-format clang-tidy; do
    if ! command -v $program &> /dev/null; then
        echo "Error: $program not found, install it first and then re-run the script."
        exit 1
    fi
done


rm -rf deps_install

mkdir -p deps_build
mkdir -p deps_install

export CXX=$(which clang++)
export CC=$(which clang)
export LIB_BUILD_PREFIX="$(pwd)/deps_build"
export LIB_INSTALL_PREFIX="$(pwd)/deps_install"

if [[ "${1-s}" == "-p" ]]; then
    echo "Building in parallel."
    set -euxo pipefail

    pids=()

    ./build_boost.sh &
    pids+=($!)

    ./build_benchmark.sh &
    pids+=($!)

    ./build_gtest.sh &
    pids+=($!)

    ./build_fmt.sh &
    pids+=($!)

    ./build_sbe.sh &
    pids+=($!)
    
    exit_code=0
    for pid in "${pids[@]}"; do
        wait "$pid" || exit_code=1
    done

    if [ "$exit_code" == "1" ]; then
        echo "Build failed."
        exit 1
    fi
else
    echo "Building sequentially."
    set -euxo pipefail

    ./build_boost.sh && ./build_benchmark.sh && ./build_gtest.sh && ./build_fmt.sh && ./build_sbe.sh
fi

set +x

echo "
Dependencies installed and compiled. Building debug targets...
"

rm -rf build
mkdir -p build
cmake -S . -B build -GNinja
ninja -C build sbe
ninja -C build
ln -fs build/compile_commands.json .

echo "
Build complete
"

if [[ -z ${USES_NIX} ]]; then
    echo "
    Persist the following in your current shell (or use direnv with the ./.envrc):

        export CXX=$(which clang++)
        export CC=$(which clang)
        export LIB_INSTALL_PREFIX=$(pwd)/deps_install
        export LIB_BUILD_PREFIX=$(pwd)/deps_install

    Run the tests: ./build/src/test"
fi

echo "Bye :)"

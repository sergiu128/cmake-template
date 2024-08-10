#!/bin/bash

echo "Setting up"

mkdir -p deps_build
mkdir -p deps_install
export LIB_BUILD_PREFIX="$(pwd)/deps_build"
export LIB_INSTALL_PREFIX="$(pwd)/deps_install"

if [[ "$1" == "-p" ]]; then
    echo "Building in parallel."
    pids=()

    ./build_boost.sh &
    pids+=($!)

    ./build_google_test_benchmark.sh &
    pids+=($!)

    ./build_fmt.sh &
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
    ./build_boost.sh && ./build_google_test_benchmark.sh && ./build_fmt.sh
fi

echo ""
echo "Dependencies installed and compiled. Building..."
echo ""

mkdir -p build
cmake -S . -B build -GNinja
ninja -C build
ln -fs build/compile_commands.json .

echo ""
echo "Build complete!"
echo ""

echo "Persist the following in your current shell: "
echo ""
echo "    export LIB_INSTALL_PREFIX=$(pwd)/deps_install"
echo ""
echo "Run the tests: ./build/src/test"
echo ""
echo "Bye :)"

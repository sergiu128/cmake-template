#!/usr/bin/env bash

# docs: https://github.com/real-logic/simple-binary-encoding/wiki/Cpp-User-Guide

LIB_BUILD_PREFIX=${LIB_BUILD_PREFIX:-/tmp}
LIB_SBE_BUILD_PREFIX=${LIB_SBE_BUILD_PREFIX:-${LIB_BUILD_PREFIX}}
LIB_SBE_VERSION="1.34.0"

cd "${LIB_SBE_BUILD_PREFIX}"
if [ ! -d simple-binary-encoding ]; then
    HOME=/dev/null git clone https://github.com/real-logic/simple-binary-encoding.git
fi

cd simple-binary-encoding
git fetch
git checkout "${LIB_SBE_VERSION}"

./gradlew
stat "sbe-all/build/libs/sbe-all-${LIB_SBE_VERSION}.jar"

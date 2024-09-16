#!/bin/bash

set -exo pipefail

# install/build prefix common to all libs
LIB_INSTALL_PREFIX=${LIB_INSTALL_PREFIX:-/usr/local}
LIB_BUILD_PREFIX=${LIB_BUILD_PREFIX:-/tmp}

LIB_BOOST_VERSION=1.86.0
LIB_BOOST_INSTALL_PREFIX=${LIB_BOOST_INSTALL_PREFIX:-${LIB_INSTALL_PREFIX}}
LIB_BOOST_BUILD_PREFIX=${LIB_BOOST_BUILD_PREFIX:-${LIB_BUILD_PREFIX}}

LIB_BOOST_TOOLSET=${LIB_BOOST_TOOLSET:-clang}

echo "Building boost with toolset=${LIB_BOOST_TOOLSET}"

cd "$LIB_BOOST_BUILD_PREFIX"
if [ ! -d boost ]; then
    HOME=/dev/null git clone https://github.com/boostorg/boost.git
fi

cd boost
git fetch
git checkout "boost-$LIB_BOOST_VERSION"

# Everything below libs/core should also appear in ./b2 install below
# UNLESS the library is header only. Header only libraries do not need to be built.
#
# You can get a list of libraries which require building by going to external/boost
# and running "./bootstrap.sh --show-libraries". Some libs will have dependencies, so
# you gotta sort that out yourself.
submodules="tools/build
            tools/boost_install
            libs/headers
            libs/core
            libs/assert
            libs/static_assert
            libs/integer
            libs/mpl
            libs/bind
            libs/function
            libs/preprocessor
            libs/smart_ptr
            libs/concept_check
            libs/utility
            libs/numeric
            libs/array
            libs/lexical_cast
            libs/range
            libs/detail
            libs/exception
            libs/io
            libs/algorithm
            libs/throw_exception
            libs/type_traits
            libs/type_index
            libs/any
            libs/config
            libs/container_hash
            libs/iterator
            libs/predef
            libs/regex
            libs/program_options
            libs/move
            libs/intrusive
            libs/tokenizer
            libs/container
            libs/parameter
            libs/mp11
            libs/fusion
            libs/typeof
            libs/serialization
            libs/tuple
            libs/describe
            libs/accumulators"

for submodule in $submodules; do
    HOME=/dev/null git submodule update --init "$submodule"
done

./bootstrap.sh --with-toolset=clang --prefix="${LIB_BOOST_INSTALL_PREFIX}"

function build_boost() {
    ./b2 clean
    ./b2 headers
    ./b2 install -q -a \
         --prefix="${LIB_BOOST_INSTALL_PREFIX}" \
         --build-type=minimal \
         --layout=system \
         --buildid=${1} \
         --disable-icu \
         --with-regex \
         --with-program_options \
         --with-container \
         toolset=${LIB_BOOST_TOOLSET} \
         stdlib=native \
         cxxflags="-std=c++20" \
         link=static runtime-link=static \
         threading=single address-model=64 \
         variant=${1}
}

build_boost debug
build_boost release

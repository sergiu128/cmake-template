function(set_version)
    execute_process(
        COMMAND bash -c "git describe --tags"
        OUTPUT_VARIABLE TEMPLATE_VERSION)
    string(REGEX REPLACE "\n$" "" TEMPLATE_VERSION "${TEMPLATE_VERSION}")
    message("version: ${TEMPLATE_VERSION}")
    add_definitions("-DTEMPLATE_VERSION=\"${TEMPLATE_VERSION}\"")
endfunction()

function(set_revision)
    execute_process(
        COMMAND bash -c "git rev-parse HEAD"
        OUTPUT_VARIABLE TEMPLATE_REVISION)
    string(REGEX REPLACE "\n$" "" TEMPLATE_REVISION "${TEMPLATE_REVISION}")
    message("revision: ${TEMPLATE_REVISION}")
    add_definitions("-DTEMPLATE_REVISION=\"${TEMPLATE_REVISION}\"")
endfunction()

function(config_compiler)
    message("Configuring compiler...")

    # Callers may pass cmdline flags with -DCMAKE_CXX_FLAGS=... .
    # This script overwrites CMAKE_CXX_FLAGS_DEBUG and CMAKE_CXX_FLAGS_RELEASE.

    if ("${CMAKE_BUILD_TYPE}" STREQUAL "" OR "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
        set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Debug build, no optimizations" FORCE)
        set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g" CACHE STRING "Debug build flags" FORCE)
        message("Building Debug target. Flags: ${CMAKE_CXX_FLAGS_DEBUG} ${CMAKE_CXX_FLAGS}")
    elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON CACHE BOOL "Enables link time optimization" FORCE)
        set(CMAKE_CXX_FLAGS_RELEASE "-O3 -g" CACHE STRING "Release build flags" FORCE)
        message("Building Release target. Flags: ${CMAKE_CXX_FLAGS_RELEASE} ${CMAKE_CXX_FLAGS}")
    else ()
        message(FATAL_ERROR "Invalid build type: ${CMAKE_BUILD_TYPE}")
    endif()

    set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL "Export compile definitions to make clangd(LSP) work." FORCE)
    set(CMAKE_CXX_EXTENSIONS OFF CACHE BOOL "We don't use GNU's C++ extensions." FORCE)
    set(CMAKE_CXX_STANDARD 23 CACHE STRING "We use C++23." FORCE)
    set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE BOOL "We error if the compiler does not support C++23." FORCE)

    if (DEFINED ENV{USES_NIX})
        message("On nix, linking with lld")
        set(CMAKE_LINKER_TYPE LLD CACHE STRING "Use lld to link on nix." FORCE)
    endif()

    add_compile_options(-Wall -Wextra -Werror -Wpedantic)

    message("Configured compiler. Using ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
endfunction()

include("cmake/libbenchmark.cmake")
include("cmake/libgtest.cmake")
include("cmake/libboost.cmake")
#include("cmake/libfmt.cmake") # deprecated in favor of C++23's std::format
include("cmake/libsbe.cmake")

function(load_libs)
    message("-----------------------------libs-----------------------------")
    setup_benchmark()
    message("--------------------------------------------------------------")
    setup_gtest()
    message("--------------------------------------------------------------")
    setup_boost()
    message("--------------------------------------------------------------")
    #setup_fmt()
    #message("--------------------------------------------------------------")
    setup_sbe()
    message("--------------------------------------------------------------")
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads REQUIRED)
    message("-----------------------------libs-----------------------------")
endfunction()

function(setup_environment)
    config_compiler()
    set_version()
    set_revision()
    load_libs()
endfunction()

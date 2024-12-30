cmake_minimum_required(VERSION 3.30)

project(template LANGUAGES CXX)

include("cmake/setup_environment.cmake")
setup_environment()

# libraries
add_subdirectory("lib")
add_subdirectory("util")
add_subdirectory("sbe")

# binaries
add_subdirectory("src")

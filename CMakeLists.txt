cmake_minimum_required(VERSION 3.13)

project(template LANGUAGES CXX)

include("cmake/setup_environment.cmake")
setup_environment()

# libraries
add_subdirectory("lib")
add_subdirectory("util")

# binaries
add_subdirectory("src")

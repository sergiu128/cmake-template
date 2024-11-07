# cmake-template

This is a `cmake` project template that makes it easy to quickly start working on a C++ project on Unix platforms.

## Getting started

Easiest is with `nix`. Install it, invoke `nix-shell` and in that shell run `./setup.sh`.

Building Release targets:
```
mkdir build_rel
cd build_rel
cmake -DCMAKE_BUILD_TYPE=Release ../
```

`CMAKE_BUILD_TYPE` can be `Debug`(default)/`Release`.

To make this your own, replace all occurences of `TEMPLATE` with your project's name.

## What does it do?
- Statically links against minimal version of [Boost](https://www.boost.org/)
  with the most useful libraries. Add new ones in `build_boost.sh` and link
  against them in `cmake/libboost.cmake`.
- Statically links against [HdrHistogram\_c](https://github.com/HdrHistogram/HdrHistogram_c).
- Statically links against [Google Benchmark](https://github.com/google/benchmark)
  and [Google Test](https://github.com/google/googletest).
- Statically links against [fmt](https://github.com/fmtlib/fmt).
- Uses `clang++` and `C++20` for everything. It works out of the box on Linux
  and BSD systems. It is also possible to build the dependencies and project itself with `g++`. Just set `CXX` and `CC`
  accordingly.
- Provides an easy way to setup tests and benchmarks:
    - If you want to write a test for `file.cpp`, then create `file.test.cpp`,
      write your tests and then run them from `./build/src/test`. All project
      tests are run by `./build/src/test` that is built from `src/main.test.cpp`.
    - If you want to write a benchmark for `file.cpp`, then create `file.bm.cpp`,
      `link_benchmark` against it and then you can run it after building the
      project. All benchmarks have a separate binary i.e. there is a target
      built for each `*.bm.cpp` file. See `lib/CMakeLists.txt` for an example.
- Supports both `Release` and `Debug` targets and ensures that the statically
  linked libraries are built in the same way. That means we are actually
  building two versions of each library: `libname-release.a` and
  `libname-debug.a`.
- Adheres to most of [Google's C++ Style Guide](https://google.github.io/styleguide/cppguide.html).
  See `.clang-format`.
- Allows you to build and install libraries from a custom directory. This is
  done through the `LIB_INSTALL_PREFIX` and `LIB_BUILD_PREFIX` environment
  variables. Check `build_boost.sh` and `cmake/libboost.cmake` for examples. If
  the `LIB_INSTALL_*_PREFIX` and `LIB_BUILD_*_PREFIX` are not set, libraries are
  built in `/tmp` and installed in `/usr/local`.
  
## Misc
- linking with mold: `-DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=mold" -DCMAKE_SHARED_LINKER_FLAGS="-fuse-ld=mold"`
- checking toolchain: `readelf -p .comment src/test`

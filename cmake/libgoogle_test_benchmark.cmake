function(setup_google_benchmark)
    message("libbenchmark: setting up...")
    message("libbenchmark: include_path=${LIB_TEST_BENCHMARK_INCLUDE_PREFIX} lib_path=${LIB_TEST_BENCHMARK_LIB_PREFIX}")

    add_library(google_benchmark_debug STATIC IMPORTED GLOBAL)
    target_include_directories(google_benchmark_debug INTERFACE "${LIB_TEST_BENCHMARK_INCLUDE_PREFIX}")
    set_target_properties(google_benchmark_debug PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${LIB_TEST_BENCHMARK_INCLUDE_PREFIX}"
            IMPORTED_LOCATION "${LIB_TEST_BENCHMARK_LIB_PREFIX}/libbenchmark-debug.a")

    add_library(google_benchmark_release STATIC IMPORTED GLOBAL)
    target_include_directories(google_benchmark_release INTERFACE "${LIB_TEST_BENCHMARK_INCLUDE_PREFIX}")
    set_target_properties(google_benchmark_release PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${LIB_TEST_BENCHMARK_INCLUDE_PREFIX}"
            IMPORTED_LOCATION "${LIB_TEST_BENCHMARK_LIB_PREFIX}/libbenchmark-release.a")

    message("libbenchmark: setup successful")
endfunction()

function(setup_google_test)
    message("libgtest: setting up...")
    message("libgtest: include_path=${LIB_TEST_BENCHMARK_INCLUDE_PREFIX} lib_path=${LIB_TEST_BENCHMARK_LIB_PREFIX} ")

    add_library(google_test_debug STATIC IMPORTED GLOBAL)
    target_include_directories(google_test_debug INTERFACE "${LIB_TEST_BENCHMARK_INCLUDE_PREFIX}")
    set_target_properties(google_test_debug PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${LIB_TEST_BENCHMARK_INCLUDE_PREFIX}"
            IMPORTED_LOCATION "${LIB_TEST_BENCHMARK_LIB_PREFIX}/libgtest-debug.a")

    add_library(google_test_release STATIC IMPORTED GLOBAL)
    target_include_directories(google_test_release INTERFACE "${LIB_TEST_BENCHMARK_INCLUDE_PREFIX}")
    set_target_properties(google_test_release PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${LIB_TEST_BENCHMARK_INCLUDE_PREFIX}"
            IMPORTED_LOCATION "${LIB_TEST_BENCHMARK_LIB_PREFIX}/libgtest-release.a")

    message("libgtest: setup successful")
endfunction()

function(setup_google_test_benchmark)
    if (DEFINED ENV{LIB_TEST_BENCHMARK_INSTALL_PREFIX})
        set(LIB_TEST_BENCHMARK_INSTALL_PREFIX "$ENV{LIB_TEST_BENCHMARK_INSTALL_PREFIX}" CACHE PATH "Location of google benchmark/test for the local build")
    elseif(DEFINED ENV{LIB_INSTALL_PREFIX})
        set(LIB_TEST_BENCHMARK_INSTALL_PREFIX "$ENV{LIB_INSTALL_PREFIX}" CACHE PATH "Location of google benchmark/test for the local build")
    else()
        set(LIB_TEST_BENCHMARK_INSTALL_PREFIX "/usr/local" CACHE PATH "Location of google benchmark/test for the local build")
    endif()

    message("libgtest libbenchmark install prefix: ${LIB_TEST_BENCHMARK_INSTALL_PREFIX}")

    set(LIB_TEST_BENCHMARK_INCLUDE_PREFIX "${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/include" CACHE PATH "Location of google benchmark/test headers")
    set(LIB_TEST_BENCHMARK_LIB_PREFIX "${LIB_TEST_BENCHMARK_INSTALL_PREFIX}/lib" CACHE PATH "Location of google benchmark/test libraries")

    setup_google_benchmark()
    setup_google_test()
endfunction()

file(GLOB SOURCES CONFIGURE_DEPENDS "*.cpp")
list(FILTER SOURCES EXCLUDE REGEX "(\.bm)|(\.test)")

add_library(template_util STATIC ${SOURCES})

target_include_directories(template_util PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(template_util PUBLIC
    debug boost_debug
    optimized boost_release)

add_library(template::util ALIAS template_util)

include("${CMAKE_SOURCE_DIR}/cmake/link_benchmark.cmake")
list(APPEND LINK_BM_DEBUG boost_debug)
list(APPEND LINK_BM_RELEASE boost_release)
list(APPEND LINK_BM_BOTH template::util)
link_benchmarks(${LINK_BM_DEBUG} ${LINK_BM_RELEASE} ${LINK_BM_BOTH})

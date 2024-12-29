add_library(template_sbe INTERFACE)

target_include_directories(template_sbe INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/include")
add_library(template::sbe ALIAS template_sbe)

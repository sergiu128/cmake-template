function (setup_fmt)
    if (DEFINED ENV{LIB_FMT_INSTALL_PREFIX})
        set(LIB_FMT_INSTALL_PREFIX "$ENV{LIB_FMT_INSTALL_PREFIX}" CACHE PATH "Location of fmt for the local build")
    elseif (DEFINED ENV{LIB_INSTALL_PREFIX})
        set(LIB_FMT_INSTALL_PREFIX "$ENV{LIB_INSTALL_PREFIX}" CACHE PATH "Location of fmt for the local build")
    else()
        set(LIB_FMT_INSTALL_PREFIX "/usr/local" CACHE PATH "Location of fmt for the local build")
    endif()
    set(LIB_FMT_INCLUDE_PREFIX "${LIB_FMT_INSTALL_PREFIX}/include" CACHE PATH "Location of fmt headers")
    set(LIB_FMT_LIB_PREFIX "${LIB_FMT_INSTALL_PREFIX}/lib" CACHE PATH "Location of fmt libraries")

    message("libfmt: setting up...")
    message("libfmt: include_path=${LIB_FMT_INCLUDE_PREFIX} lib_path=${LIB_FMT_LIB_PREFIX}")

    add_library(fmt_debug STATIC IMPORTED GLOBAL)
    target_include_directories(fmt_debug INTERFACE "${LIB_FMT_INCLUDE_PREFIX}")
    set_target_properties(fmt_debug PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${LIB_FMT_INCLUDE_PREFIX}"
        IMPORTED_LOCATION
        "${LIB_FMT_LIB_PREFIX}/libfmt-debug.a")

    add_library(fmt_release STATIC IMPORTED GLOBAL)
    target_include_directories(fmt_release INTERFACE "${LIB_FMT_INCLUDE_PREFIX}")
    set_target_properties(fmt_release PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${LIB_FMT_INCLUDE_PREFIX}"
        IMPORTED_LOCATION
        "${LIB_FMT_LIB_PREFIX}/libfmt-release.a")

    message("libfmt: setup successful")
endfunction()

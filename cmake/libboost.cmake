macro(add_boost_library libname)
    string(TOUPPER ${libname} libname_upper)

    message("libboost: linking ${libname}")

    add_library(boost_${libname}_debug STATIC IMPORTED GLOBAL)
    set_target_properties(boost_${libname}_debug PROPERTIES
            IMPORTED_LOCATION "${LIB_BOOST_LIB_PREFIX}/libboost_${libname}-debug.a"
            INTERFACE_COMPILE_DEFINITIONS "HAVE_BOOST_${libname_upper}_DEBUG")
    list(APPEND BOOST_LIBS_DEBUG "boost_${libname}_debug")

    add_library(boost_${libname}_release STATIC IMPORTED GLOBAL)
    set_target_properties(boost_${libname}_release PROPERTIES
            IMPORTED_LOCATION "${LIB_BOOST_LIB_PREFIX}/libboost_${libname}-release.a"
            INTERFACE_COMPILE_DEFINITIONS "HAVE_BOOST_${libname_upper}_RELEASE")
    list(APPEND BOOST_LIBS_RELEASE "boost_${libname}_release")
endmacro()

function(setup_boost)
    if (DEFINED ENV{LIB_BOOST_INSTALL_PREFIX})
        set(LIB_BOOST_INSTALL_PREFIX "$ENV{LIB_BOOST_INSTALL_PREFIX}" CACHE PATH "Location of boost for the local build")
    elseif (DEFINED ENV{LIB_INSTALL_PREFIX})
        set(LIB_BOOST_INSTALL_PREFIX "$ENV{LIB_INSTALL_PREFIX}" CACHE PATH "Location of boost for the local build")
    else()
        set(LIB_BOOST_INSTALL_PREFIX "/usr/local" CACHE PATH "Location of boost for the local build")
    endif()

    message("libboost install prefix: ${LIB_BOOST_INSTALL_PREFIX}")

    set(LIB_BOOST_INCLUDE_PREFIX "${LIB_BOOST_INSTALL_PREFIX}/include" CACHE PATH "Location of boost headers")
    set(LIB_BOOST_LIB_PREFIX "${LIB_BOOST_INSTALL_PREFIX}/lib" CACHE PATH "Location of boost libraries")

    message("libboost: setting up...")
    message("libboost: include_path=${LIB_BOOST_INCLUDE_PREFIX} lib_path=${LIB_BOOST_LIB_PREFIX}")

    add_library(boost_debug INTERFACE IMPORTED)
    add_library(boost_release INTERFACE IMPORTED)

    # start boost libs (all these are linked to boost)
    add_boost_library(program_options)
    # end boost libs

    message("libboost: debug_libs=${BOOST_LIBS_DEBUG}")
    message("libboost: release_libs=${BOOST_LIBS_RELEASE}")

    set_target_properties(boost_debug PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${LIB_BOOST_INCLUDE_PREFIX}"
            INTERFACE_LINK_LIBRARIES "${BOOST_LIBS_DEBUG}"
            INTERFACE_COMPILE_DEFINITIONS "HAVE_BOOST_DEBUG")
    set_target_properties(boost_release PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${LIB_BOOST_INCLUDE_PREFIX}"
            INTERFACE_LINK_LIBRARIES "${BOOST_LIBS_RELEASE}"
            INTERFACE_COMPILE_DEFINITIONS "HAVE_BOOST_RELEASE")

    message("libboost: setup successful")
endfunction()

function(setup_sbe)
    if (DEFINED ENV{LIB_SBE_BUILD_PREFIX})
        set(LIB_SBE_BUILD_PREFIX "$ENV{LIB_SBE_BUILD_PREFIX}" CACHE PATH "Path to the sbe generation tool")
    elseif (DEFINED ENV{LIB_BUILD_PREFIX})
        set(LIB_SBE_BUILD_PREFIX "$ENV{LIB_BUILD_PREFIX}" CACHE PATH "Path to the sbe generation tool")
    else()
        set(LIB_SBE_BUILD_PREFIX "/tmp" CACHE PATH "Location of boost for the local build")
    endif()

    set(SBE_VERSION "1.34.0")
    set(SBE_SCHEMA "${CMAKE_SOURCE_DIR}/sbe-example-schema.xml" CACHE STRING "Path for the SBE schema to generate headers from")
    set(SBE_GEN "${LIB_SBE_BUILD_PREFIX}/simple-binary-encoding/sbe-all/build/libs/sbe-all-${SBE_VERSION}.jar")
    set(SBE_OUTPUT "${CMAKE_SOURCE_DIR}/sbe/include/")

    add_custom_target(sbe
        COMMAND java -Dsbe.generate.ir=false -Dsbe.target.language=Cpp -Dsbe.target.namespace=sbe -Dsbe.output.dir=${SBE_OUTPUT} -Dsbe.errorLog=yes -jar ${SBE_GEN} ${SBE_SCHEMA}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        VERBATIM
    )

    message("sbe version: ${SBE_VERSION}")
    message("sbe schema: ${SBE_SCHEMA}")
    message("sbe generator: ${SBE_GEN}")
    message("sbe output: ${SBE_OUTPUT}")
endfunction()

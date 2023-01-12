cmake_minimum_required(VERSION 3.22)

project(NoitaShutdown
    VERSION 2.0.0
    LANGUAGES
)

find_package(Python3 3.10 REQUIRED Interpreter)

set(CPACK_GENERATOR "ZIP" CACHE STRING "")

install(DIRECTORY shutdown
    DESTINATION "."
)

add_subdirectory(bluescreen)

find_program(OPTIPNG NAMES optipng REQUIRED)

install(CODE "
    execute_process(
        COMMAND find \"\${CMAKE_INSTALL_PREFIX}/shutdown\" -type f -name *.png
            -exec \"${OPTIPNG}\" -o3 -strip all -- {} +
    )

    execute_process(
        COMMAND find \"\${CMAKE_INSTALL_PREFIX}/shutdown\"
            -exec touch \"--date=2020-04-28T8:30\" -- {} +
    )
")

set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY OFF)
set(CPACK_VERBATIM_VARIABLES YES)
set(CPACK_PACKAGE_FILE_NAME ${PROJECT_NAME}-${PROJECT_VERSION})
include(CPack)

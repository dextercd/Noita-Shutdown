cmake_minimum_required(VERSION 3.22)

project(NoitaShutdown LANGUAGES)

find_package(Python3 3.10 REQUIRED Interpreter)

set(CPACK_GENERATOR "ZIP" CACHE STRING "")

install(DIRECTORY files
    DESTINATION "shutdown"
)

install(
    FILES
        init.lua
        mod.xml
        settings.lua
    DESTINATION "shutdown"
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

set(CPACK_VERBATIM_VARIABLES YES)
include(CPack)

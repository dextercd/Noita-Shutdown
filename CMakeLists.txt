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

include(CPack)

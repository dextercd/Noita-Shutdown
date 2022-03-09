set(SHUTDOWN_BSOD_FONT ${CMAKE_CURRENT_SOURCE_DIR}/segoe_slboot.ttf
    CACHE FILEPATH ""
)

add_custom_command(
    OUTPUT completed.png completed.xml
    DEPENDS generate_completed.py ${SHUTDOWN_BSOD_FONT}

    VERBATIM
    COMMAND Python3::Interpreter
        ${CMAKE_CURRENT_SOURCE_DIR}/generate_completed.py
        --font ${SHUTDOWN_BSOD_FONT}
        --image-out completed.png
        --sprite-xml-out completed.xml
)

add_custom_target(completed ALL
    DEPENDS
        completed.png
        completed.xml
)

install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/completed.png
        ${CMAKE_CURRENT_BINARY_DIR}/completed.xml
    DESTINATION "shutdown/files/ui_gfx/bluescreen"
)

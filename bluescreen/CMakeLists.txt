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

add_custom_command(
    OUTPUT stop_code.png stop_code.xml
    DEPENDS generate_stop_code.py ${SHUTDOWN_BSOD_FONT}

    VERBATIM
    COMMAND Python3::Interpreter
        ${CMAKE_CURRENT_SOURCE_DIR}/generate_stop_code.py
        --font ${SHUTDOWN_BSOD_FONT}
        --image-out stop_code.png
        --sprite-xml-out stop_code.xml
)

add_custom_target(stop_code ALL
    DEPENDS
        stop_code.png
        stop_code.xml
)

add_custom_command(
    OUTPUT qr_code.png qr_code.xml
    DEPENDS generate_qr_code.py

    VERBATIM
    COMMAND Python3::Interpreter
        ${CMAKE_CURRENT_SOURCE_DIR}/generate_qr_code.py
        --image-out qr_code.png
        --sprite-xml-out qr_code.xml
)

add_custom_target(qr_code ALL
    DEPENDS
        qr_code.png
        qr_code.xml
)

install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/completed.png
        ${CMAKE_CURRENT_BINARY_DIR}/completed.xml
        ${CMAKE_CURRENT_BINARY_DIR}/stop_code.png
        ${CMAKE_CURRENT_BINARY_DIR}/stop_code.xml
        ${CMAKE_CURRENT_BINARY_DIR}/qr_code.png
        ${CMAKE_CURRENT_BINARY_DIR}/qr_code.xml
    DESTINATION "shutdown/files/ui_gfx/bluescreen"
)

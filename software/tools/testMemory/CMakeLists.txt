add_application("testMemory" testMemory.c CONSOLE)
target_link_libraries(testMemory board_defs driver_control)

add_application("programROM" programROM.c flash.c CONSOLE)
target_link_libraries(programROM buserror declrom_header enc624j600)

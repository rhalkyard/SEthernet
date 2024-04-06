# Since portions of the enc624j600 library are called in performance-critical
# parts of the driver, build separate versions tuned for the SE and SE/30. The
# 68000-tuned SE version is still 'good enough' to be used by diagnostics etc.
# on both machines.

option(REV0_SUPPORT "Enable workarounds for rev0 hardware bugs" OFF)

add_library(enc624j600 STATIC enc624j600.c)
target_link_libraries(enc624j600 PRIVATE memtest)
target_include_directories(enc624j600 PUBLIC include/)
target_compile_options(enc624j600 PRIVATE -m68000 -mtune=68000)
target_compile_definitions(enc624j600 PUBLIC "$<$<BOOL:${REV0_SUPPORT}>:REV0_SUPPORT>")

add_library(enc624j600_030 STATIC enc624j600.c)
target_link_libraries(enc624j600_030 PRIVATE memtest)
target_include_directories(enc624j600_030 PUBLIC include/)
target_compile_options(enc624j600_030 PRIVATE -m68030 -mtune=68030)
target_compile_definitions(enc624j600_030 PUBLIC "$<$<BOOL:${REV0_SUPPORT}>:REV0_SUPPORT>")

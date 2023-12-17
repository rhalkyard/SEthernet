add_library(enc624j600 STATIC enc624j600.c)
target_link_libraries(enc624j600 PRIVATE memtest)
target_include_directories(enc624j600 PUBLIC include/)

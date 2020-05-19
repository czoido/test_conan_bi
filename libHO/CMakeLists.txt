cmake_minimum_required(VERSION 2.8)
project(dummy_lib_ho CXX)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()


file(GLOB HEADERS include/*)

add_library(libHO INTERFACE)
target_include_directories(libHO INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

install(FILES ${HEADERS}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/include
        PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
cmake_minimum_required(VERSION 3.14)

if($ENV{CI_PIPELINE_ID})
    set(PROJECT_VERSION_PATCH $ENV{CI_PIPELINE_ID})
else()
    set(PROJECT_VERSION_PATCH 42) # local build version
endif()

project(clang_format_example VERSION 1.0.${PROJECT_VERSION_PATCH})

# set(CMAKE_CXX_CLANG_TIDY clang-tidy -warnings-as-errors=-* -checks=-*,readability-*,cppcoreguidelines-*,boost-*,performance-*,portability-*,misc-*,modernize-*,bugprone-*)
# set(CMAKE_LINK_WHAT_YOU_USE TRUE)
set(CMAKE_CXX_STANDARD 17)

configure_file(conf/version.h.in version.h)

find_package(Threads REQUIRED)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
include(ClangFormat)

include_directories(
        ${CMAKE_CURRENT_BINARY_DIR}
)

add_executable(${CMAKE_PROJECT_NAME}
    main.cpp
    beast/session.h
    beast/session.cpp
)

target_clangformat_setup(${CMAKE_PROJECT_NAME})

target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE
    -Wall
    -Werror
    -Wextra
    -Wpedantic
    -Wshadow
)

set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
)

target_link_libraries(${CMAKE_PROJECT_NAME}
    pthread
)

set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

install(TARGETS ${CMAKE_PROJECT_NAME} RUNTIME DESTINATION bin)

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${CMAKE_PROJECT_NAME})
set(CPACK_PACKAGE_VENDOR "Otus")

set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")

set(CPACK_GENERATOR RPM)
include(CPack)

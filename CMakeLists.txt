cmake_minimum_required(VERSION 3.9)
project(SyclSTL CXX)
set(CMAKE_CXX_STANDARD 20)

enable_testing()

option(PARALLEL_STL_BENCHMARKS "Build the internal benchmarks" OFF)
option(USE_COMPUTECPP "Use ComputeCPP" ON)

message(STATUS " Path to CMAKE source directory: ${CMAKE_SOURCE_DIR} ")
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules/)
find_package(Threads REQUIRED)

set(WARNING_FLAGS "-Wall -Wextra -Wshadow -Wdouble-promotion -Wundef -fno-common -Winit-self -Wuninitialized -Wmissing-declarations -Woverloaded-virtual")
set(OPT_FLAGS "-march=native -mtune=native -Ofast -fomit-frame-pointer")
set(CMAKE_CXX_FLAGS_RELEASE  "${OPT_FLAGS} ${WARNING_FLAGS}")
set(CMAKE_CXX_FLAGS_DEBUG "${WARNING_FLAGS} -Og -g3")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/../cmake)

find_package(hipSYCL CONFIG REQUIRED)

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif ()

if (NOT HIPSYCL_DEBUG_LEVEL)
    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        set(HIPSYCL_DEBUG_LEVEL 3 CACHE STRING
                "Choose the debug level, options are: 0 (no debug), 1 (print errors), 2 (also print warnings), 3 (also print general information)"
                FORCE)
    else ()
        set(HIPSYCL_DEBUG_LEVEL 2 CACHE STRING
                "Choose the debug level, options are: 0 (no debug), 1 (print errors), 2 (also print warnings), 3 (also print general information)"
                FORCE)
    endif ()
endif ()


cmake_policy(SET CMP0005 NEW)
add_definitions(-DHIPSYCL_DEBUG_LEVEL=0)

include_directories(${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR})


# PSTL specific
include_directories("include")
add_subdirectory (src)
add_subdirectory (examples)
add_subdirectory (tests)

add_subdirectory (benchmarks)


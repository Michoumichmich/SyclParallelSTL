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
set(COMPILE_OPTIONS "${OPT_FLAGS} ${WARNING_FLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE  "${COMPILE_OPTIONS}")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/../cmake)

find_package(hipSYCL CONFIG REQUIRED)


#add_compile_definitions(HIPSYCL_DEBUG_LEVEL="${HIPSYCL_DEBUG_LEVEL}")
#Use add_definitions for now for older cmake versions
cmake_policy(SET CMP0005 NEW)
add_definitions(-DHIPSYCL_DEBUG_LEVEL=${HIPSYCL_DEBUG_LEVEL})

include_directories(${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR})

#include_directories("/usr/local/include/")

# PSTL specific
include_directories("include")

add_subdirectory (src)
add_subdirectory (examples)
add_subdirectory (tests)

add_subdirectory (benchmarks)


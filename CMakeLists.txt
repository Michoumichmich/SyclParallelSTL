cmake_minimum_required(VERSION 3.9)
project(SyclSTL LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

enable_testing()
include(CTest)
option(PARALLEL_STL_BENCHMARKS "Build the internal benchmarks" ON)
#option(USE_COMPUTECPP "Use ComputeCPP" ON)

message(STATUS " Path to CMAKE source directory: ${CMAKE_SOURCE_DIR} ")
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules/)
find_package(Threads)

set(WARNING_FLAGS "-Wall -Wextra -Wshadow -Wdouble-promotion -fno-common -Winit-self -Wuninitialized -Wmissing-declarations -Woverloaded-virtual ")
set(OPT_FLAGS "-march=native -mtune=native -Ofast -fomit-frame-pointer")
set(CMAKE_CXX_FLAGS_RELEASE  "${OPT_FLAGS} -Wno-inline-namespace-reopened-noninline")
set(CMAKE_CXX_FLAGS_DEBUG " -g -g3 -ggdb -Og ")

include(FindSYCL.cmake)

include_directories(${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR})

# PSTL specific
include_directories("include")
add_subdirectory (src)
add_subdirectory (examples)
add_subdirectory (tests)
add_subdirectory (benchmarks)
if (PARALLEL_STL_BENCHMARKS)

endif()

add_executable(main main.cpp)
add_sycl_to_target(TARGET main)

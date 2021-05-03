set(A_SYCL_FOUND false)

find_package(hipSYCL CONFIG)
if (hipSYCL_FOUND)
    set(A_SYCL_FOUND true)
    if (NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Release)
    endif ()

    cmake_policy(SET CMP0005 NEW)
    add_definitions(-DHIPSYCL_DEBUG_LEVEL=0)

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
endif ()

if (COMPUTECPP_PACKAGE_ROOT_DIR)
    set(A_SYCL_FOUND true)
    include(FindComputeCpp)
    message(STATUS " Using ComputeCpp CMake")
    message(STATUS " Path to ComputeCpp implementation: ${COMPUTECPP_PACKAGE_ROOT_DIR} ")
    set(CMAKE_CXX_STANDARD 11)
    include(FindOpenCL)
    include(FindComputeCpp)
    add_definitions(-DSYCL_PSTL_USE_OLD_ALGO)
    set(COMPUTECPP_DEVICE_COMPILER_FLAGS "${COMPUTECPP_DEVICE_COMPILER_FLAGS} -DSYCL_PSTL_USE_OLD_ALGO")
    include_directories("${COMPUTECPP_INCLUDE_DIRECTORY}")
endif ()


if (TRISYCL_INCLUDE_DIR AND NOT A_SYCL_FOUND)
    set(A_SYCL_FOUND true)
    message(STATUS " Using triSYCL CMake")
    include(FindTriSYCL)
endif ()


if (NOT A_SYCL_FOUND)
    set(CMAKE_CXX_FLAGS "-fsycl -fsycl-targets=spir64_x86_64-unknown-unknown-sycldevice,nvptx64-nvidia-cuda-sycldevice -sycl-std=2020 -std=c++20 -fsycl-unnamed-lambda -Wno-unknown-cuda-version")
    function(add_sycl_to_target)
    endfunction()
endif ()
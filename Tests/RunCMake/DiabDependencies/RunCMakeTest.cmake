include(RunCMake)

if(NOT EXISTS "${CMake_TEST_Diab_TOOLCHAIN_FILE}")
  message(FATAL_ERROR "A licensed Diab toolchain file is required")
endif()
set(RunCMake_TEST_BINARY_DIR "${RunCMake_BINARY_DIR}/Dependencies-build")
run_cmake_with_options(Dependencies
  "-DCMAKE_TOOLCHAIN_FILE=${CMake_TEST_Diab_TOOLCHAIN_FILE}"
  -DCMAKE_BUILD_TYPE=Debug)
set(RunCMake_TEST_NO_CLEAN 1)
run_cmake_command(Dependencies-check ${CMAKE_COMMAND}
  "-Dbuild_dir=${RunCMake_TEST_BINARY_DIR}"
  -P "${RunCMake_SOURCE_DIR}/check.cmake")

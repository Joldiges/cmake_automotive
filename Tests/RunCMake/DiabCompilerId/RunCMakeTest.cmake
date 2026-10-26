include(RunCMake)

set(RunCMake_TEST_BINARY_DIR "${RunCMake_BINARY_DIR}/VersionMacros-build")
run_cmake(VersionMacros)
set(RunCMake_TEST_NO_CLEAN 1)
run_cmake_command(VersionMacros-build ${CMAKE_COMMAND} --build . --config Debug)
run_cmake_command(VersionMacros-check ${CMAKE_COMMAND}
  "-Dbuild_dir=${RunCMake_TEST_BINARY_DIR}"
  -P "${RunCMake_SOURCE_DIR}/check.cmake")

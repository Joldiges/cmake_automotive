include("${CMAKE_ROOT}/Modules/Compiler/Diab-DetermineCompiler.cmake")
file(READ "${CMAKE_ROOT}/Modules/CMakePlatformId.h.in" platform_content)
set(PREFIX "")
set(MACRO_DEC DEC)
string(CONFIGURE "${_compiler_id_version_compute}" version_content @ONLY)

foreach(case IN ITEMS legacy modern partial missing)
  set(macros "#undef __VERSION__
#undef __VERSION_MAJOR_NUMBER__
#undef __VERSION_MINOR_NUMBER__
#undef __VERSION_ARCH_FEATURE_NUMBER__
#undef __VERSION_BUG_FIX_NUMBER__
#define COMPILER_ID \"Diab\"
")
  if(case STREQUAL "legacy")
    string(APPEND macros "#define __VERSION__ \"5.9.9.0\"\n")
  elseif(case STREQUAL "modern")
    string(APPEND macros "#define __VERSION__ \"99.0.0.0\"
#define __VERSION_MAJOR_NUMBER__ 10
#define __VERSION_MINOR_NUMBER__ 2
#define __VERSION_ARCH_FEATURE_NUMBER__ 3
#define __VERSION_BUG_FIX_NUMBER__ 4
")
  elseif(case STREQUAL "partial")
    string(APPEND macros "#define __VERSION__ \"8.1.0.0\"
#define __VERSION_MAJOR_NUMBER__ 8
")
  else()
    string(APPEND macros "#define __VERSION_MAJOR_NUMBER__ 8\n")
  endif()
  foreach(lang IN ITEMS C CXX)
    set(CMAKE_${lang}_COMPILER_ID_CONTENT "${macros}${version_content}")
    set(CMAKE_${lang}_COMPILER_ID_PLATFORM_CONTENT "${platform_content}")
    if(lang STREQUAL "C")
      set(ext c)
    else()
      set(ext cpp)
    endif()
    configure_file("${CMAKE_ROOT}/Modules/CMake${lang}CompilerId.${ext}.in"
      "${CMAKE_CURRENT_BINARY_DIR}/${case}.${ext}" @ONLY)
  endforeach()
  add_library(${case} OBJECT
    "${CMAKE_CURRENT_BINARY_DIR}/${case}.c"
    "${CMAKE_CURRENT_BINARY_DIR}/${case}.cpp")
  file(GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/objects-${case}-$<CONFIG>.txt"
    CONTENT "$<JOIN:$<TARGET_OBJECTS:${case}>,\n>\n")
endforeach()

enable_language(C CXX)
foreach(lang IN ITEMS C CXX)
  if(NOT CMAKE_${lang}_COMPILER_ID STREQUAL "Diab")
    message(FATAL_ERROR "${lang}: expected automatic Diab identification")
  endif()
endforeach()
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include")
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/include/direct.h"
  "#include <indirect.h>\n#define DIRECT_VALUE 10\n")
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/include/indirect.h"
  "#define INDIRECT_VALUE 20\n")
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/consumer.c"
  "#include \"direct.h\"\nint consumer_c(void) { return DIRECT_VALUE + INDIRECT_VALUE; }\n")
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/consumer.cpp"
  "#include \"direct.h\"\nint consumer_cpp() { return DIRECT_VALUE + INDIRECT_VALUE; }\n")
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/unrelated.c"
  "int unrelated(void) { return 123; }\n")
add_library(consumers OBJECT
  "${CMAKE_CURRENT_BINARY_DIR}/consumer.c"
  "${CMAKE_CURRENT_BINARY_DIR}/consumer.cpp")
target_include_directories(consumers SYSTEM PRIVATE
  "${CMAKE_CURRENT_BINARY_DIR}/include")
add_library(unrelated OBJECT "${CMAKE_CURRENT_BINARY_DIR}/unrelated.c")
file(GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/objects-$<CONFIG>.txt"
  CONTENT "$<JOIN:$<TARGET_OBJECTS:consumers>,\n>\n$<JOIN:$<TARGET_OBJECTS:unrelated>,\n>\n")

cmake_minimum_required(VERSION 3.13)
project(aff4tsk LANGUAGES C)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

find_package(Threads REQUIRED)

find_path(AFF4_INCLUDE_DIR aff4/aff4-c.h)
find_library(AFF4_LIBRARY aff4)

find_path(TSK_INCLUDE_DIR tsk/libtsk.h)
find_library(TSK_LIBRARY tsk)

if (NOT AFF4_INCLUDE_DIR OR NOT AFF4_LIBRARY)
  message(FATAL_ERROR "AFF4 library not found. Please set AFF4_INCLUDE_DIR and AFF4_LIBRARY.")
endif()

if (NOT TSK_INCLUDE_DIR OR NOT TSK_LIBRARY)
  message(FATAL_ERROR "TSK library not found. Please set TSK_INCLUDE_DIR and TSK_LIBRARY.")
endif()

# --------------------
# Shared library
# --------------------
add_library(aff4tsk SHARED
  aff4_tsk_img.c
)

target_include_directories(aff4tsk PRIVATE
  ${AFF4_INCLUDE_DIR}
  ${TSK_INCLUDE_DIR}
)

target_link_libraries(aff4tsk
  ${TSK_LIBRARY}
  ${AFF4_LIBRARY}
  Threads::Threads
)

# --------------------
# Test executable
# --------------------
add_executable(test_aff4tsk
  test.c
)

# Link test against the library we just built
target_link_libraries(test_aff4tsk
  aff4tsk
  ${TSK_LIBRARY}
  ${AFF4_LIBRARY}
  Threads::Threads
)

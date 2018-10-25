cmake_minimum_required(VERSION 3.0)

project(superglu VERSION 1.3.0)
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)

string(TIMESTAMP SUPERGLU_BUILD_YEAR "%Y")
math(EXPR SUPERGLU_SO_VERSION ${PROJECT_VERSION_MAJOR}*20)

# ############################################################################
# Prevent in-source builds, as they often cause severe build problems
# ############################################################################
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "${CMAKE_PROJECT_NAME} requires an out of source build. Please create a separate build directory and run 'cmake path_to_${CMAKE_PROJECT_NAME} [options]' there.")
endif()

# ############################################################################
# Include necessary submodules
# ############################################################################

include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

# ############################################################################
# Provide options to customise the build
# ############################################################################

option(SUPERGLU_BUILD_SHARED_LIBS "Build shared libraries" OFF)

# ############################################################################
# Find all necessary and optional superglu dependencies
# ############################################################################

# Fail early if one of the required packages cannot be found

find_package(OpenGL REQUIRED)
find_package(Perl REQUIRED)

# ##########################################################################
# Setup build environment
# ##########################################################################

if(NOT CMAKE_BUILD_TYPE)
  # Has no effect for multi configuration generators (VisualStudio, Xcode).
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose type of build, options are Debug, Release, RelWithDebInfo, MinSizeRel." FORCE)
endif()
# Set common output directories for all targets built.
# First for the generic no-config case (e.g. with mingw)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
# Second, for multi-config builds (e.g. msvc)
foreach (_config ${CMAKE_CONFIGURATION_TYPES})
  string(TOUPPER ${_config} _config)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${_config} "${CMAKE_BINARY_DIR}/lib")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${_config} "${CMAKE_BINARY_DIR}/lib")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${_config} "${CMAKE_BINARY_DIR}/bin")
endforeach()

check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(stdint.h HAVE_STDINT_H)
check_include_file(stddef.h HAVE_STDDEF_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(string.h HAVE_STRING_H)
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(ctype.h HAVE_CTYPE_H)
check_include_file(memory.h HAVE_MEMORY_H)
check_include_file(unistd.h HAVE_UNISTD_H)
check_include_file(dlfcn.h HAVE_DLFCN_H)
check_include_file(windows.h HAVE_WINDOWS_H)
check_include_files("stdlib.h;stdarg.h;string.h;float.h" STDC_HEADERS)

# ############################################################################
# Setup targets in subdirectories
# ############################################################################

add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/superglu.h
  DEPENDS ${CMAKE_SOURCE_DIR}/specs/enumglu.spec ${CMAKE_SOURCE_DIR}/specs/glu.spec ${CMAKE_SOURCE_DIR}/cfg/genheader.pl
  COMMAND ${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/cfg/genheader.pl ${CMAKE_SOURCE_DIR}/specs/enumglu.spec ${CMAKE_SOURCE_DIR}/specs/glu.spec > ${CMAKE_BINARY_DIR}/superglu.h
)

include_directories(${CMAKE_BINARY_DIR})
configure_file(include/config.h.cmake.in config.h)

# Get all compilation units.
set(SUPERGLU_SOURCE ${CMAKE_BINARY_DIR}/superglu.h CACHE INTERNAL "SUPERGLU_SOURCE")

add_subdirectory(libnurbs)
add_subdirectory(libtess)
add_subdirectory(libutil)

# Setup the library.
if(WIN32)
  if(MINGW)
    set(SUPERGLU_DEFAULT_SHARED_POSTFIX "")
    set(SUPERGLU_DEFAULT_STATIC_POSTFIX "")
  else()
    set(SUPERGLU_DEFAULT_SHARED_POSTFIX "")
    set(SUPERGLU_DEFAULT_STATIC_POSTFIX s)
  endif()
  if(SUPERGLU_BUILD_SHARED_LIBS)
    set(SUPERGLU_DEFAULT_POSTFIX ${SUPERGLU_DEFAULT_SHARED_POSTFIX})
  else()
    set(SUPERGLU_DEFAULT_POSTFIX ${SUPERGLU_DEFAULT_STATIC_POSTFIX})
  endif()
  set(CMAKE_RELEASE_POSTFIX ${SUPERGLU_DEFAULT_POSTFIX})
  set(CMAKE_MINSIZEREL_POSTFIX ${SUPERGLU_DEFAULT_POSTFIX})
  set(CMAKE_RELWITHDEBINFO_POSTFIX ${SUPERGLU_DEFAULT_POSTFIX})
  set(CMAKE_DEBUG_POSTFIX ${SUPERGLU_DEFAULT_POSTFIX}d)
endif()

if(SUPERGLU_BUILD_SHARED_LIBS)
  add_library(GLU SHARED ${SUPERGLU_SOURCE})
else()
  add_library(GLU STATIC ${SUPERGLU_SOURCE})
endif()

set_target_properties(GLU PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${SUPERGLU_SO_VERSION})

target_compile_definitions(GLU PRIVATE HAVE_CONFIG_H LIBRARYBUILD GLU_INTERNAL GLU_DEBUG=$<CONFIG:Debug>)

if(WIN32)
  if(MSVC)
    target_compile_definitions(GLU PRIVATE _CRT_NONSTDC_NO_DEPRECATE _CRT_SECURE_NO_DEPRECATE _CRT_SECURE_NO_WARNINGS _USE_MATH_DEFINES)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W2")
  endif()
  if(SUPERGLU_BUILD_SHARED_LIBS)
    target_compile_definitions(GLU PRIVATE GLU_MAKE_DLL INTERFACE GLU_DLL)
  else()
    target_compile_definitions(GLU INTERFACE GLU_NOT_DLL)
    if(MSVC)
      set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Z7")                       # Override default /Zi to embed
      set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /Z7")     # debugging info in the .lib.
    endif()
  endif()
endif()

target_include_directories(GLU
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}>
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/libnurbs/interface>
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/libnurbs/internals>
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/libnurbs/nurbtess>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>
  PRIVATE
    ${OPENGL_INCLUDE_DIRS}
)

target_link_libraries(GLU PUBLIC ${OPENGL_gl_LIBRARY})

# ############################################################################
# Install headers and binaries
# ############################################################################

install(FILES ${CMAKE_BINARY_DIR}/superglu.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} COMPONENT development)

install(TARGETS GLU EXPORT ${PROJECT_NAME}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT runtime
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT runtime NAMELINK_SKIP
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT development
)

if(SUPERGLU_BUILD_SHARED_LIBS)
  install(TARGETS GLU EXPORT ${PROJECT_NAME} LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT development NAMELINK_ONLY)
  if(MSVC)
    install(FILES $<TARGET_PDB_FILE:GLU> DESTINATION ${CMAKE_INSTALL_BINDIR} CONFIGURATIONS Debug RelWithDebInfo COMPONENT debug)
  endif()
endif()

# ############################################################################
# Install CMake config package files
# ############################################################################

configure_package_config_file(${PROJECT_NAME}-config.cmake.in ${PROJECT_NAME_LOWER}-config.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}-${PROJECT_VERSION}
)

write_basic_package_version_file("${CMAKE_BINARY_DIR}/${PROJECT_NAME_LOWER}-config-version.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY ExactVersion
)

# To make the component usable not only from the install directory but also from the build directory
export(
  TARGETS GLU
  FILE ${PROJECT_NAME_LOWER}-export.cmake
)

install(FILES "${CMAKE_BINARY_DIR}/${PROJECT_NAME_LOWER}-config.cmake" "${CMAKE_BINARY_DIR}/${PROJECT_NAME_LOWER}-config-version.cmake"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}-${PROJECT_VERSION}
  COMPONENT development
)

install(EXPORT ${PROJECT_NAME}
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}-${PROJECT_VERSION}
  NAMESPACE ${PROJECT_NAME}::
  FILE ${PROJECT_NAME_LOWER}-export.cmake
  COMPONENT development
)

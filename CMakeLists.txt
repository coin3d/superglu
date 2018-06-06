cmake_minimum_required(VERSION 3.0)

project(superglu VERSION "1.3.0")

# Disallow in-source build
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
	message(FATAL_ERROR "${CMAKE_PROJECT_NAME} requires an out of source build. Please create a separate build directory and run 'cmake path_to_${CMAKE_PROJECT_NAME} [options]' there.")
endif()

include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

find_package(OpenGL REQUIRED)
find_package(Perl REQUIRED)

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

option(SUPERGLU_BUILD_SHARED_LIBS "Build shared libraries" OFF)

# Naming
if(WIN32)
	if(MSVC)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W2")
	endif()
	if(SUPERGLU_BUILD_SHARED_LIBS)
		set(CMAKE_DEBUG_POSTFIX d)
	else()
		set(CMAKE_RELEASE_POSTFIX s)
		set(CMAKE_MINSIZEREL_POSTFIX s)
		set(CMAKE_RELWITHDEBINFO_POSTFIX s)
		set(CMAKE_DEBUG_POSTFIX sd)
		if(MSVC)
			set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Z7")                       # Override default /Zi to embed
			set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /Z7")     # debugging info in the .lib.
		endif()
	endif()
endif()

configure_file(include/config.h.cmake.in config.h)

# source files
set(SUPERGLU_SOURCE "" CACHE INTERNAL "SUPERGLU_SOURCE")
add_subdirectory(libnurbs)
add_subdirectory(libtess)
add_subdirectory(libutil)

if(SUPERGLU_BUILD_SHARED_LIBS)
	add_library(GLU SHARED ${SUPERGLU_SOURCE})
	target_compile_definitions(GLU PRIVATE GLU_MAKE_DLL INTERFACE GLU_DLL)
else()
	add_library(GLU STATIC ${SUPERGLU_SOURCE})
	target_compile_definitions(GLU INTERFACE GLU_NOT_DLL)
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
set_target_properties(GLU PROPERTIES VERSION ${PROJECT_VERSION})

add_custom_command(TARGET GLU PRE_BUILD
	DEPENDS ${CMAKE_SOURCE_DIR}/specs/enumglu.spec ${CMAKE_SOURCE_DIR}/specs/glu.spec ${CMAKE_SOURCE_DIR}/cfg/genheader.pl
	COMMAND ${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/cfg/genheader.pl ${CMAKE_SOURCE_DIR}/specs/enumglu.spec ${CMAKE_SOURCE_DIR}/specs/glu.spec > ${CMAKE_BINARY_DIR}/superglu.h
)

set(SUPERGLU_COMPILE_DEFINITIONS HAVE_CONFIG_H LIBRARYBUILD GLU_INTERNAL)
if(MSVC)
	set(SUPERGLU_COMPILE_DEFINITIONS ${SUPERGLU_COMPILE_DEFINITIONS} _CRT_SECURE_NO_WARNINGS _CRT_SECURE_NO_DEPRECATE _CRT_NONSTDC_NO_WARNINGS)
endif()
target_compile_definitions(GLU PRIVATE ${SUPERGLU_COMPILE_DEFINITIONS})

install(FILES ${CMAKE_BINARY_DIR}/superglu.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} COMPONENT development)

install(TARGETS GLU EXPORT superglu
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT runtime
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT runtime NAMELINK_SKIP
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT development
)

if(SUPERGLU_BUILD_SHARED_LIBS)
	install(TARGETS GLU EXPORT superglu LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT development NAMELINK_ONLY)
	if(MSVC)
		install(FILES $<TARGET_PDB_FILE:GLU> DESTINATION ${CMAKE_INSTALL_BINDIR} CONFIGURATIONS Debug RelWithDebInfo COMPONENT debug)
	endif()
endif()

# Support find_package(superglu NO_MODULE).
configure_package_config_file(superglu-config.cmake.in superglu-config.cmake
	INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/superglu-${PROJECT_VERSION}
)

write_basic_package_version_file(${CMAKE_BINARY_DIR}/superglu-config-version.cmake
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY ExactVersion
)

# To make the component usable not only from the install directory but also from the build directory
export(
	TARGETS GLU
	FILE superglu-export.cmake
)

install(FILES ${CMAKE_BINARY_DIR}/superglu-config.cmake ${CMAKE_BINARY_DIR}/superglu-config-version.cmake
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/superglu-${PROJECT_VERSION}
	COMPONENT development
)

install(EXPORT superglu
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/superglu-${PROJECT_VERSION}
	NAMESPACE superglu::
	FILE superglu-export.cmake
	COMPONENT development
)

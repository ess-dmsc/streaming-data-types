# Just a cmake example of generating the flatbuffer headers.
# Personally, I like to generate these headers from the projects
# which use them.

# Tries to locate flatc with find_program.

cmake_minimum_required(VERSION 2.8.11)
project(streaming-data-types)

if(EXISTS "${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
	include("${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
	conan_basic_setup(SKIP_RPATH NO_OUTPUT_DIRS)
endif()

find_program(FLATC flatc)
message("** Found flatc: ${FLATC}")

set(flatbuffers_generated_headers "")
set(schemas_subdir "schemas")
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${schemas_subdir}")
file(GLOB_RECURSE flatbuffers_schemata RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/schemas" "schemas/*.fbs")

foreach (f0 ${flatbuffers_schemata})
	string(REGEX REPLACE "\\.fbs$" "" s0 ${f0})
	set(fbs "${schemas_subdir}/${s0}.fbs")
	set(fbh "${schemas_subdir}/${s0}_generated.h")
	add_custom_command(
		OUTPUT "${fbh}"
		COMMAND ${FLATC} --cpp --gen-mutable --gen-name-strings --scoped-enums "${CMAKE_CURRENT_SOURCE_DIR}/${fbs}"
		DEPENDS "${fbs}"
		WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${schemas_subdir}"
		COMMENT "Process ${fbs} using ${FLATC}"
	)
	list(APPEND flatbuffers_generated_headers "${CMAKE_CURRENT_BINARY_DIR}/${fbh}")
endforeach()

add_custom_target(flatbuffers_generate ALL DEPENDS ${flatbuffers_generated_headers})

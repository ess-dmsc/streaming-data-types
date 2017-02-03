# Just a cmake example of generating the flatbuffer headers.
# Personally, I like to generate these headers from the projects
# which use them.

# Assumes that 'flatc' is in PATH.

cmake_minimum_required(VERSION 2.8.11)
project(streaming-data-types)

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
		COMMAND flatc --cpp --gen-mutable --gen-name-strings --scoped-enums "${CMAKE_CURRENT_SOURCE_DIR}/${fbs}"
		DEPENDS "${fbs}"
		WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${schemas_subdir}"
		COMMENT "Process ${fbs} using ${flatc}"
	)
	list(APPEND flatbuffers_generated_headers "${CMAKE_CURRENT_BINARY_DIR}/${fbh}")
endforeach()

add_custom_target(flatbuffers_generate ALL DEPENDS ${flatbuffers_generated_headers})
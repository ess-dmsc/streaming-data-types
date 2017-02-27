# Streaming Data Types

FlatBuffers is the format chosen for the ESS messaging system.

We would like to be able to read any message in the system at any time,
therefore:

All schemas that we use for the transmission of data are collected in this
repository.

The names of the schema files in this repository are prefixed by their unique
4-character `file_identifier`.  This `file_identifier` must be set in the
schema definition file as:
```
file_identifier = "abcd";
```

The schema ids must be unique on the network.

Table of schema file identifiers follows later in this README.

To get your very own file identifier, please just pick one available and
document it here in the README and do upload the schema as well.


## Namespace

Please namespace your schema so that the generated c++ headers do not collide.
Including e.g. the schema id in the namespace name avoids any collision.


## Backwards compatibility

Please, avoid changes which break binary compatibility.  Flatbuffers documentation contains
good information about how to maintain binary compatibility.
If you need to make breaking changes, acquire a new schema id.


## Not enough file identifiers available?

If you feel that you may need a lot of schema ids, you can use a single schema
and work with the flat buffers union data type in your root element.


## Naming

Please prefix your schema files in this repository with your chosen schema id
so that we can easily avoid id collisions.


## Schema ids

```
ID (hex)      Flatbuffer schema file name

0xf140        f140-general.fbs          Can encode an arbitrary EPICS PV
0xf141        f141-ntarraydouble.fbs    A simple array of double, testing file writing
0xrit0        rit0-psi_sinq_schema.fbs  Neutron event data according the RITA2
```

##Automatic downloading and compilation of schema files
It is possible to have CMake download the schema files and generate C++ header files from those schema files automatically. Instructions are as follows.

1. You will need to download the files `DownloadProject.cmake` and `DownloadProject.CMakeLists.cmake.in` from the following [page](https://gist.github.com/SkyToGround/b458ecbef74e11c880a4774058c6f560) and put them in a CMake modules project of your project repository (e.g. `cmake_modules`).
2. Set the CMake modules directory in your `CMakeLists.txt` file, (e.g. `set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake_modules)`).
3. The code for actually downloading and compiling the schemas follows. Modify it to suit your needs.

```CMake
include(DownloadProject)
download_project(PROJ streaming-data-types GIT_REPOSITORY https://github.com/ess-dmsc/streaming-data-types.git GIT_TAG master)
file(GLOB fb_schemata_files "${streaming-data-types_SOURCE_DIR}/schemas/*.fbs")
set(fb_header_INC "${PROJECT_SOURCE_DIR}/src/schemas")
find_program(flatc flatc PATHS "$ENV{flatc}" "$ENV{HOME}/.tools" "/opt/local/flatbuffers")
foreach (fb_file ${fb_schemata_files})
	message(STATUS "Generating header file for ${fb_file}.")
	execute_process(COMMAND ${flatc} --cpp --gen-mutable --gen-name-strings --scoped-enums -o ${fb_header_INC} ${fb_file})
endforeach()
```

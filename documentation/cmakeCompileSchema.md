#Automatic downloading and compilation of schema files

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

# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Подключение библиотеки Protobuf
# ----------------------------------------------------------------

include_guard(GLOBAL)

find_package(Protobuf CONFIG REQUIRED)

get_target_property(PROTOBUF_INC_PATH protobuf::libprotobuf INTERFACE_INCLUDE_DIRECTORIES)
if(NOT PROTOBUF_INC_PATH)
    message(WARNING "UMBA: protobuf::libprotobuf does not provide INTERFACE_INCLUDE_DIRECTORIES")
else()
    if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE)
        message(STATUS "UMBA: PROTOBUF_INC_PATH: ${PROTOBUF_INC_PATH}")
    endif()
endif()


# G:\vcpkg\installed\x64-mingw-static\tools\protobuf\protoc.exe
find_program(UMBA_PROTOBUF_PROTOC protoc 
             PATHS "${UMBA_VCPKG_TARGET_TRIPLET_TOOLS_BINARY_ROOT}/protobuf"
                   "${UMBA_VCPKG_INSTALLED_LIBS_ROOT}/${UMBA_VCPKG_HOST_SYSARCH_PREFIX}/tools/protobuf"
                   "${UMBA_VCPKG_INSTALLED_LIBS_ROOT}/${UMBA_VCPKG_HOST_SYSARCH_PREFIX}-static/tools/protobuf"
                   "${UMBA_VCPKG_INSTALLED_LIBS_ROOT}/${UMBA_VCPKG_HOST_SYSARCH_PREFIX}-dynamic/tools/protobuf"
                   "$ENV{PROTOC_BIN}"
                   "$ENV{PROTOC_HOME}/bin")

if (NOT UMBA_PROTOBUF_PROTOC)
    message(WARNING "UMBA: protobuf: protoc not found in ${UMBA_VCPKG_TARGET_TRIPLET_TOOLS_BINARY_ROOT}/protobuf or in ${UMBA_VCPKG_INSTALLED_LIBS_ROOT}/${UMBA_VCPKG_HOST_SYSARCH_PREFIX}/tools/protobuf")
    set(UMBA_PROTOBUF_PROTOC Protobuf_PROTOC_EXECUTABLE)
else()
    message(STATUS "UMBA: UMBA_PROTOBUF_PROTOC: ${UMBA_PROTOBUF_PROTOC}")
endif()


# if 
# C:\vcpkg\installed\x64-windows\tools\protobuf\

# UMBA_VCPKG_ROOT
# VCPKG_MANIFEST_MODE
# ${CMAKE_BINARY_DIR}/vcpkg_installed
# ${VCPKG_ROOT}/installed

# find_program(UMBA_PROTOBUF_PROTOC protoc PATHS "$ENV{PROTOC_BIN}" "$ENV{PROTOC_HOME}/bin")


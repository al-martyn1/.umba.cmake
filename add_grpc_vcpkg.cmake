# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Подключение библиотеки gRPC
# ----------------------------------------------------------------

include_guard(GLOBAL)


find_package(gRPC CONFIG REQUIRED)
#find_program(GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)

get_target_property(GRPC_INC_PATH gRPC::grpc++ INTERFACE_INCLUDE_DIRECTORIES)
if(NOT GRPC_INC_PATH)
    message(WARNING "UMBA: gRPC::grpc++ does not provide INTERFACE_INCLUDE_DIRECTORIES")
else()
    if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE)
        message(STATUS "UMBA: GRPC_INC_PATH: ${GRPC_INC_PATH}")
    endif()
endif()

find_program(UMBA_GRPC_CPP_PLUGIN grpc_cpp_plugin 
             PATHS "${UMBA_VCPKG_TARGET_TRIPLET_TOOLS_BINARY_ROOT}/grpc"
                   "${UMBA_VCPKG_INSTALLED_LIBS_ROOT}/${UMBA_VCPKG_HOST_SYSARCH_PREFIX}/tools/grpc"
                   "${UMBA_VCPKG_INSTALLED_LIBS_ROOT}/${UMBA_VCPKG_HOST_SYSARCH_PREFIX}-static/tools/grpc"
                   "${UMBA_VCPKG_INSTALLED_LIBS_ROOT}/${UMBA_VCPKG_HOST_SYSARCH_PREFIX}-dynamic/tools/grpc"
                   "$ENV{PROTOC_BIN}"
                   "$ENV{PROTOC_HOME}/bin")

set(gRPC_CPP_PLUGIN_EXECUTABLE "${UMBA_GRPC_CPP_PLUGIN}") # compat
set(GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE "${UMBA_GRPC_CPP_PLUGIN}") # compat

if (NOT UMBA_GRPC_CPP_PLUGIN)
    message(WARNING "UMBA: gRPC: grpc_cpp_plugin not found in ${UMBA_VCPKG_TARGET_TRIPLET_TOOLS_BINARY_ROOT}/grpc or in ${UMBA_VCPKG_INSTALLED_LIBS_ROOT}/${UMBA_VCPKG_HOST_SYSARCH_PREFIX}/tools/grpc")
    set(UMBA_GRPC_CPP_PLUGIN grpc_cpp_plugin)
else()
    message(STATUS "UMBA: UMBA_GRPC_CPP_PLUGIN: ${UMBA_GRPC_CPP_PLUGIN}")
endif()                                           

set(UMBA_GRPC_CPP_PLUGIN "${GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE}") # compatibility

# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Математические функции
# ----------------------------------------------------------------

include_guard(GLOBAL)


find_package(gRPC CONFIG REQUIRED)
find_program(GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)
set(gRPC_CPP_PLUGIN_EXECUTABLE "${GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE}") # compatibility

get_target_property(GRPC_INC_PATH gRPC::grpc++ INTERFACE_INCLUDE_DIRECTORIES)
if(NOT GRPC_INC_PATH)
    message(WARNING "UMBA: gRPC::grpc++ does not provide INTERFACE_INCLUDE_DIRECTORIES")
else()
    if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE)
        message(STATUS "UMBA: GRPC_INC_PATH: ${GRPC_INC_PATH}")
    endif()
endif()


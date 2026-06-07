# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Математические функции
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

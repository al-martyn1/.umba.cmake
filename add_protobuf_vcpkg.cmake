# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Подключение библиотеки Protobuf
# ----------------------------------------------------------------

include_guard(GLOBAL)

find_package(Protobuf CONFIG REQUIRED)
set_target_properties(protobuf::libprotobuf PROPERTIES INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "$<TARGET_PROPERTY:protobuf::libprotobuf,INTERFACE_INCLUDE_DIRECTORIES>")
#set_target_properties(protobuf::libprotobuf-lite PROPERTIES INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "$<TARGET_PROPERTY:protobuf::libprotobuf-lite,INTERFACE_INCLUDE_DIRECTORIES>")
# Используйте код с осторожностью.Этот метод гарантирует, что компилятор проигнорирует C4371 исключительно внутри кода Protobuf.Способ 2. Локальное подавление в коде (Если предупреждение идет из .pb.h файлов)Если предупреждение вызывают файлы, сгенерированные утилитой protoc (.pb.h), вы можете обернуть их включение в прагмы компилятора. Это отключит предупреждение только на момент чтения этих файлов:cpp#if defined(_MSC_VER)
#     #pragma warning(push)
#     #pragma warning(disable : 4371) // Отключаем C4371 только для Protobuf
# #endif
# 
# #include "your_file.pb.h" // Подключение сгенерированного файла
# 
# #if defined(_MSC_VER)
#     #pragma warning(pop) // Возвращаем исходные настройки предупреждений для вашего кода
# #endif
# Используйте код с осторожностью.Способ 3. Синхронизация стандартов C++Проверьте, какой стандарт C++ задан в вашем проекте. Попробуйте явно выставить в CMakeLists.txt тот же стандарт, с которым vcpkg собирает современные библиотеки (рекомендуется C++17 или C++20):cmakeset(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)
# Используйте код с осторожностью.Чтобы помочь точнее, подскажите: предупреждение C4371 указывает на какой-то конкретный файл (например, заголовок из недр vcpkg или ваш сгенерированный .pb.h)? Какой стандарт C++ сейчас настроен в вашем CMakeLists.txt?

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


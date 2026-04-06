# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Главная Umba
# ----------------------------------------------------------------

cmake_minimum_required(VERSION 3.25)

include_guard(GLOBAL)


# UMBA_CMAKE_VERBOSE - Включает детальный лог CMake
# UMBA_CMAKE_TRACE - Включает максимально детальный лог CMake. Не работает без UMBA_CMAKE_VERBOSE# UMBA_CMAKE_TRACE_ENV_PATH) - включает вывод системной переменной PATH. Также должны быть определены переменные UMBA_CMAKE_VERBOSE и UMBA_CMAKE_TRACE.
# UMBA_CMAKE_TRACE_UMBA_ADD_TARGET_PROTOBUF_PROTO_FILES - включает трассировку функций umba_add_target_protobuf_proto_files*. . Также должны быть определены переменные UMBA_CMAKE_VERBOSE и UMBA_CMAKE_TRACE.
# UMBA_LIB_ROOT_INCLUDE_DISABLE - запрещение подключения LIB_ROOT в пути поиска подключаемых файлов
# UMBA_LIB_ROOT_INCLUDE_AS_SYSTEM - подключать содержимое LIB_ROOT как системные инклюды, или как пользовательские. Влияет на строгость проверки качества кода.


include("${CMAKE_CURRENT_LIST_DIR}/functions_base.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/strlib.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/pathlib.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/mathlib.cmake")
# include("${CMAKE_CURRENT_LIST_DIR}/umba_vcpkg.cmake")


#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
#umba_path_split_pathlist_env_var(VCPKG_OVERLAY_TRIPLETS_PATH_LIST VCPKG_OVERLAY_TRIPLETS)
#    message(STATUS "===== VCPKG_OVERLAY_TRIPLETS_PATH_LIST =====")
#    foreach(VCPKG_OVERLAY_TRIPLETS_PATH_LIST_ITEM ${VCPKG_OVERLAY_TRIPLETS_PATH_LIST})
#        message(STATUS "    ${VCPKG_OVERLAY_TRIPLETS_PATH_LIST_ITEM}")
#    endforeach()
#    message(STATUS "======================")

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
if(MSVC)

    # set_property(GLOBAL PROPERTY JOB_POOLS umba_custom_job_pool=1)

    # set(CMAKE_JOB_POOLS umba_custom_job_pool=1)
    # set(CMAKE_JOB_POOL_COMPILE umba_custom_job_pool)
    # set(CMAKE_JOB_POOL_LINK umba_custom_job_pool)

    # remove_compile_options(/MP)
    # add_compile_options(/MP1)

endif()

#----------------------------------------------------------------------------




#----------------------------------------------------------------------------
if(NOT PRJ_ROOT)

    # set(PRJ_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
    # cmake_path(SET PRJ_ROOT NORMALIZE "${CMAKE_CURRENT_LIST_DIR}/..")
    umba_path_normalize(PRJ_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
    # message(STATUS "umbaResult: ${umbaResult}")
    set(PRJ_ROOT "${PRJ_ROOT}" ) # PARENT_SCOPE

endif()


if(PRJ_ROOT)

    if(NOT LIB_ROOT)
        set(LIB_ROOT "${PRJ_ROOT}/_libs")
    endif()
    if(NOT SRC_ROOT)
        set(SRC_ROOT "${PRJ_ROOT}/_src")
    endif()

endif()


if (NOT UMBA_LIB_ROOT_INCLUDE_DISABLE)

    if (NOT UMBA_LIB_ROOT_INCLUDE_AS_SYSTEM)
        include_directories(${LIB_ROOT})
    else()
        include_directories(SYSTEM ${LIB_ROOT})
    endif()

endif()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
# GCC specific global options
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # using GCC
    # Наелся говна с GCC, когда забыт return и падает хрен знает где. 
    # Варнинги GCC в VSCode как-то незаметны, если вообще есть, аналогичные в MSVC как-то сразу видно даже без особых приседаний
    # Поэтому для GCC данный варнинг включается как ошибка всегда
    # https://stackoverflow.com/questions/42760220/how-can-i-enforce-an-error-when-a-function-doesnt-have-any-return-in-gcc
    # !!! Плохая идея была устанавливать опцию глобально - она попадала в библиотеки, и ломала их сборку. Кривые либы, о что делать
    # add_compile_options("-Werror=return-type" ) # Force error if no return statement in non-void function
endif()


if (NOT DEFINED UMBA_CMAKE_TRACE_ENV_PATH)
    set(UMBA_CMAKE_TRACE_ENV_PATH OFF)
endif()


#----------------------------------------------------------------------------
if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_ENV_PATH)

    if (CMAKE_HOST_WIN32)
        set(UMBA_PATH_STRING $ENV{PATH})
        # message(STATUS "${UMBA_PATH_STRING}")
        string(REPLACE ";" ";" UMBA_CMAKE_VERBOSE_PATH_LIST "${UMBA_PATH_STRING}")
    else()
        set(UMBA_PATH_STRING "$ENV{PATH}")
        string(REPLACE ":" ";" UMBA_CMAKE_VERBOSE_PATH_LIST "${UMBA_PATH_STRING}")
    endif()

    message(STATUS "===== CMake PATH =====")
    foreach(UMBA_CMAKE_VERBOSE_PATH_ITEM ${UMBA_CMAKE_VERBOSE_PATH_LIST})
        message(STATUS "    ${UMBA_CMAKE_VERBOSE_PATH_ITEM}")
    endforeach()
    message(STATUS "======================")

endif()

# execute_process(
#     COMMAND where protoc   # или where protoc на Windows
#     OUTPUT_VARIABLE PROTOC_PATH
#     OUTPUT_STRIP_TRAILING_WHITESPACE
# )
# message(STATUS "where protoc: ${PROTOC_PATH}")

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
if(DEFINED ENV{UMBA_TOOLS})

    if (UMBA_CMAKE_VERBOSE)
            message(STATUS "Found environment variable 'UMBA_TOOLS': $ENV{UMBA_TOOLS}") # NOTICE
    endif()

    find_program(UMBA_SUBST_MACROS_EXECUTABLE umba-subst-macros PATHS "$ENV{UMBA_TOOLS}/bin")

else()

    find_program(UMBA_SUBST_MACROS_EXECUTABLE umba-subst-macros)

endif()


if (UMBA_SUBST_MACROS_EXECUTABLE)

    if (UMBA_CMAKE_VERBOSE)
        message(STATUS "Found umba-subst-macros tool: ${UMBA_SUBST_MACROS_EXECUTABLE}") # NOTICE
    endif()

    # set(ENV{UMBA_SUBST_MACROS_EXECUTABLE} "${UMBA_SUBST_MACROS_EXECUTABLE}")

else()

    set(UMBA_SUBST_MACROS_EXECUTABLE "") # UMBA_SUBST_MACROS_EXECUTABLE может быть вида *_NOT_FOUND, это тоже FALSE

endif()


if(DEFINED ENV{UMBA_SUBST_MACROS_EXECUTABLE})

    if (UMBA_CMAKE_VERBOSE)
            message(STATUS "Found environment variable 'UMBA_SUBST_MACROS_EXECUTABLE': $ENV{UMBA_SUBST_MACROS_EXECUTABLE}") # NOTICE
    endif()

endif()
#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
# Protobuf

# Протобафовский protoc должен быть установлен в системе
# В данном случае не важно, кросскомпиляция у нас или нет (или важно?)

# В C++ исходниках используется макрос PROTOBUF_VERSION для проверки версии
# Номер немного странный
# при protoc.exe --version выдающем libprotoc 31.1, PROTOBUF_VERSION равно значению 6031001, 
# при protoc.exe --version выдающем libprotoc 33.0-rc1 PROTOBUF_VERSION = 6033000
# Похоже, что 6 - это хз что, а 31001 соответствует версии 31.1, а 33000 - версии 33.0

# Текущий GRPC использует версию 31.1 - https://github.com/protocolbuffers/protobuf/releases/tag/v31.1

if (UMBA_USE_GRPC AND UMBA_USE_GRPC_SUBMODULE)
    set(UMBA_PROTOBUF_EXTERN_PROTOC OFF)
endif()

if (UMBA_PROTOBUF_EXTERN_PROTOC OR UMBA_PROTOBUF_PROTOC_VER_MAJOR)

    # Если не установлены UMBA_PROTOBUF_PROTOC_VER_MAJOR и UMBA_PROTOBUF_PROTOC_VER_MINOR
    # пытаемся найти через системную переменную без номера версии
    # !!! Доделать

    if (NOT UMBA_PROTOBUF_PROTOC_VER_MAJOR)
        set(UMBA_PROTOBUF_PROTOC_VER_MAJOR 31)
        if (UMBA_CMAKE_VERBOSE)
            message(STATUS "Set Protobuf protoc ver major (UMBA_PROTOBUF_PROTOC_VER_MAJOR) to: ${UMBA_PROTOBUF_PROTOC_VER_MAJOR}")
        endif()
    endif()
    
    if (NOT UMBA_PROTOBUF_PROTOC_VER_MINOR)
        set(UMBA_PROTOBUF_PROTOC_VER_MINOR 1)
        if (UMBA_CMAKE_VERBOSE)
            message(STATUS "Set Protobuf protoc ver major (UMBA_PROTOBUF_PROTOC_VER_MINOR) to: ${UMBA_PROTOBUF_PROTOC_VER_MINOR}")
        endif()
    endif()

    # Проверить системные переменные на базе UMBA_PROTOBUF_PROTOC_VER_MAJOR UMBA_PROTOBUF_PROTOC_VER_MINOR - PROTOC_M_N_BIN и PROTOC_M_N
    # !!! Доделать

    # https://cmake.org/cmake/help/latest/command/find_program.html
    find_program(UMBA_PROTOBUF_PROTOC protoc PATHS "$ENV{PROTOC_BIN}" "$ENV{PROTOC_HOME}/bin")
    # https://cmake.org/cmake/help/latest/command/message.html

else()

    set(UMBA_PROTOBUF_PROTOC $<TARGET_FILE:protobuf::protoc>)

endif()


if (UMBA_CMAKE_VERBOSE)
    if (NOT UMBA_PROTOBUF_PROTOC)
        message(NOTICE "Protobuf protoc compiler not found")
    else()
        message(STATUS "Found Protobuf protoc compiler: ${UMBA_PROTOBUF_PROTOC}")
    endif()
endif()


#----------------------------------------------------------------------------
# https://cmake.org/cmake/help/latest/variable/CMAKE_CROSSCOMPILING.html
# https://cmake.org/cmake/help/latest/variable/CMAKE_SYSTEM_NAME.html
# https://cmake.org/cmake/help/latest/variable/CMAKE_HOST_SYSTEM_NAME.html

#----------------------------------------------------------------------------
# Protobuf grpc_cpp_plugin

# See https://github.com/samoilovv/TinkoffInvestSDK/blob/main/cmake/common.cmake


if (UMBA_USE_GRPC)
    if (UMBA_USE_GRPC_SUBMODULE)
        if(CMAKE_CROSSCOMPILING)
            find_program(GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)
        else() # Host==Target
            set(GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:grpc_cpp_plugin>)
            # find_program(GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin PATHS "${CMAKE_CURRENT_BINARY_DIR}/grpc" "${LIB_ROOT}/grpc")
        endif()
    else() # GRPC installed system-wide
        find_package(gRPC CONFIG REQUIRED)
        # message(STATUS "Using gRPC ${gRPC_VERSION}")
        find_program(GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)
    endif()
    
    if (UMBA_CMAKE_VERBOSE)
        if (NOT GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE)
            message(NOTICE "GRPC Protobuf protoc compiler plugin not found")
        else()
            message(STATUS "GRPC Protobuf protoc compiler plugin : ${GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE}")
        endif()
    endif()
endif()


#----------------------------------------------------------------------------
function(umba_add_target_protobuf_grpc_proto_files_ex
         TARGET
         PROTO_FILES_MASK
         FILES_ROOT
         PROTOC_OPTS
        )

    #if(MSVC)
    if (CMAKE_GENERATOR MATCHES "Visual Studio")

        message(STATUS "Disable parallel jobs using '${CMAKE_GENERATOR}' generator for target '${TARGET}'")

        set_target_properties(${TARGET} PROPERTIES DISABLE_PARALLEL_BUILD TRUE)

        set_target_properties(${TARGET} PROPERTIES
            VS_GLOBAL_MaxCpuCount 1
            VS_GLOBAL_EnableParallelBuild false
            VS_GLOBAL_Parallel 0
            )

        # # Добавляем кастомные свойства MSBuild для цели
        # set_target_properties(${TARGET} PROPERTIES
        #     VS_GLOBAL_<ClCompile>UseMultiToolTask false
        #     VS_GLOBAL_<Link>UseMultiToolTask false
        #     VS_GLOBAL_<Lib>UseMultiToolTask false
        # )
        
        # Альтернативно, через макросы:
        set_target_properties(${TARGET} PROPERTIES
            VS_GLOBAL_ClCompileUseMultiToolTask false
            VS_GLOBAL_LinkUseMultiToolTask false
            VS_GLOBAL_LibUseMultiToolTask false
        )

    endif()

    file(GLOB PROTO_FILES_BY_MASK "${PROTO_FILES_MASK}")

    if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_UMBA_ADD_TARGET_PROTOBUF_PROTO_FILES)
        message(STATUS "=== Adding proto files to target: ${TARGET} ===")
    endif()

    set(SRC_PATH_REPLACE_TO "${CMAKE_CURRENT_BINARY_DIR}/_umba_generated_from_proto/${TARGET}")

    foreach(PROTO_FILE ${PROTO_FILES_BY_MASK})

        get_filename_component(PROTO_FILE_PATH "${PROTO_FILE}" PATH)
        string(REPLACE "${FILES_ROOT}/" "${SRC_PATH_REPLACE_TO}/" OUTPUT_PROTO_FILE_PATH_TMP "${PROTO_FILE_PATH}") # "${CMAKE_CURRENT_BINARY_DIR}/${TARGET}/"
        umba_path_normalize(umbaResult ${OUTPUT_PROTO_FILE_PATH_TMP})
        set(OUTPUT_PROTO_FILE_PATH ${umbaResult})
        target_include_directories(${TARGET} PUBLIC ${OUTPUT_PROTO_FILE_PATH})

        file(GLOB PROTO_FILES "${PROTO_FILE}")

        if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_UMBA_ADD_TARGET_PROTOBUF_PROTO_FILES)
             message(STATUS "  ${PROTO_FILE} (from ${PROTO_FILE_PATH})")
             message(STATUS "  Output path: ${OUTPUT_PROTO_FILE_PATH})")
        endif()

        # string(REPLACE ${PROTO_FILE_PATH} ${CMAKE_CURRENT_BINARY_DIR} OUTPUT_FILE_NAMES "${PROTO_FILES}")
        string(REPLACE "${FILES_ROOT}/" "${SRC_PATH_REPLACE_TO}/" OUTPUT_FILE_NAMES_TMP "${PROTO_FILES}") # "${CMAKE_CURRENT_BINARY_DIR}/${TARGET}/"
        umba_path_normalize(umbaResult ${OUTPUT_FILE_NAMES_TMP})
        set(OUTPUT_FILE_NAMES ${umbaResult})

        string(REPLACE ".proto" ".pb.cc" OUTPUT_PB_SOURCE "${OUTPUT_FILE_NAMES}")
        string(REPLACE ".proto" ".grpc.pb.cc" OUTPUT_GRPC_SOURCE "${OUTPUT_FILE_NAMES}")
        string(REPLACE ".proto" ".pb.h" OUTPUT_PB_HEADER "${OUTPUT_FILE_NAMES}")
        string(REPLACE ".proto" ".grpc.pb.h" OUTPUT_GRPC_HEADER "${OUTPUT_FILE_NAMES}")

        if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_UMBA_ADD_TARGET_PROTOBUF_PROTO_FILES)
             message(STATUS "    OUTPUT_FILE_NAMES : ${OUTPUT_FILE_NAMES})")
             message(STATUS "    OUTPUT_PB_SOURCE  : ${OUTPUT_PB_SOURCE})")
             message(STATUS "    OUTPUT_GRPC_SOURCE: ${OUTPUT_GRPC_SOURCE})")
             message(STATUS "    OUTPUT_PB_HEADER  : ${OUTPUT_PB_HEADER})")
             message(STATUS "    OUTPUT_GRPC_HEADER: ${OUTPUT_GRPC_HEADER})")
        endif()

        set(str1 "namespace public {")
        set(repl1 "namespace public_ {")
        set(str2 "::public::")
        set(repl2 "::public_::")

        # -IPATH, --proto_path=PATH

        # if (WIN32)
        if (CMAKE_HOST_WIN32)
        
            add_custom_command(
                  OUTPUT ${OUTPUT_PB_SOURCE} ${OUTPUT_PB_HEADER} ${OUTPUT_GRPC_SOURCE} ${OUTPUT_GRPC_HEADER}
                  # COMMAND ${CMAKE_COMMAND} -E echo "Acquiring lock for ${PROTO_FILE}"
                  # COMMAND ${CMAKE_COMMAND} -E lock "${CMAKE_CURRENT_BINARY_DIR}/proto.lock"
                  COMMAND ${UMBA_PROTOBUF_PROTOC}
                  ARGS 
                    --grpc_out "${OUTPUT_PROTO_FILE_PATH}"
                    --cpp_out "${OUTPUT_PROTO_FILE_PATH}"
                    "-I${PROTO_FILE_PATH}"
                    ${PROTOC_OPTS}
                    --plugin=protoc-gen-grpc="${GRPC_PROTOC_CPP_PLUGIN_EXECUTABLE}"
                    "${PROTO_FILE}"
                  # COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.cmd "${OUTPUT_PB_SOURCE}"    # cmd /C 
                  # COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.cmd "${OUTPUT_PB_HEADER}"    # cmd /C 
                  # COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.cmd "${OUTPUT_GRPC_SOURCE}"  # cmd /C 
                  # COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.cmd "${OUTPUT_GRPC_HEADER}"  # cmd /C 
                  #
                  # COMMAND powershell -ExecutionPolicy Bypass -File ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.ps1 "${OUTPUT_PB_SOURCE}"
                  # COMMAND powershell -ExecutionPolicy Bypass -File ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.ps1 "${OUTPUT_PB_HEADER}"
                  # COMMAND powershell -ExecutionPolicy Bypass -File ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.ps1 "${OUTPUT_GRPC_SOURCE}"
                  # COMMAND powershell -ExecutionPolicy Bypass -File ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.ps1 "${OUTPUT_GRPC_HEADER}"
                  # 
                  # COMMAND ${CMAKE_COMMAND} -E sleep 0.5
                  #
                  COMMAND ${CMAKE_COMMAND} -E env "UMBA_SUBST_MACROS_EXECUTABLE=${UMBA_SUBST_MACROS_EXECUTABLE}" cmd /C ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords_for_files.cmd "${OUTPUT_PB_SOURCE}" "${OUTPUT_PB_HEADER}" "${OUTPUT_GRPC_SOURCE}" "${OUTPUT_GRPC_HEADER}"
                  # COMMAND cmd /C ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords_for_files.cmd "${OUTPUT_PB_SOURCE}" "${OUTPUT_PB_HEADER}" "${OUTPUT_GRPC_SOURCE}" "${OUTPUT_GRPC_HEADER}"
                  #
                  # COMMAND ${CMAKE_COMMAND} -E echo "Releasing lock for ${PROTO_FILE}"
                  # COMMAND ${CMAKE_COMMAND} -E unlock "${CMAKE_CURRENT_BINARY_DIR}/proto.lock"
                  #
                  DEPENDS "${PROTO_FILE}")

        else()

            add_custom_command(
                  OUTPUT ${OUTPUT_PB_SOURCE} ${OUTPUT_PB_HEADER} ${OUTPUT_GRPC_SOURCE} ${OUTPUT_GRPC_HEADER}
                  COMMAND ${_PROTOBUF_PROTOC}
                  ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}"
                    --proto_path ${CMAKE_BINARY_DIR}/_deps/grpc-src/third_party/protobuf/src
                    --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
                    -I "${tink_proto_path}"
                    --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
                    "${PROTO_FILE}"
                  COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.sh ${OUTPUT_PB_SOURCE}
                  COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.sh ${OUTPUT_PB_HEADER}
                  COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.sh ${OUTPUT_GRPC_SOURCE}
                  COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/fix_cpp_keywords.sh ${OUTPUT_GRPC_HEADER}
                  DEPENDS "${PROTO_FILE}")

        endif()

        list(APPEND OUTPUT_PB_SOURCES ${OUTPUT_PB_SOURCE})
        list(APPEND OUTPUT_PB_HEADERS ${OUTPUT_PB_HEADER})
        list(APPEND OUTPUT_GRPC_SOURCES ${OUTPUT_GRPC_SOURCE})
        list(APPEND OUTPUT_GRPC_HEADERS ${OUTPUT_GRPC_HEADER})

    endforeach()

    #if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_UMBA_ADD_TARGET_PROTOBUF_PROTO_FILES)
    #     message(STATUS "OUTPUT_PB_SOURCES    : ${OUTPUT_PB_SOURCES}")
    #     message(STATUS "OUTPUT_PB_HEADERS    : ${OUTPUT_PB_HEADERS}")
    #     message(STATUS "OUTPUT_GRPC_SOURCES  : ${OUTPUT_GRPC_SOURCES}")
    #     message(STATUS "OUTPUT_GRPC_HEADERS  : ${OUTPUT_GRPC_HEADERS}")
    #endif()

    # string(JOIN <glue> <output_variable> [<input>...])
    #string(JOIN " " OUTPUT_PB_SOURCES_STR   "${OUTPUT_PB_SOURCES}"  )
    #string(JOIN " " OUTPUT_PB_HEADERS_STR   "${OUTPUT_PB_HEADERS}"  )
    #string(JOIN " " OUTPUT_GRPC_SOURCES_STR "${OUTPUT_GRPC_SOURCES}")
    #string(JOIN " " OUTPUT_GRPC_HEADERS_STR "${OUTPUT_GRPC_HEADERS}")

    #if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_UMBA_ADD_TARGET_PROTOBUF_PROTO_FILES)
    #     message(STATUS "OUTPUT_PB_SOURCES_STR    : ${OUTPUT_PB_SOURCES_STR}")
    #     message(STATUS "OUTPUT_PB_HEADERS_STR    : ${OUTPUT_PB_HEADERS_STR}")
    #     message(STATUS "OUTPUT_GRPC_SOURCES_STR  : ${OUTPUT_GRPC_SOURCES_STR}")
    #     message(STATUS "OUTPUT_GRPC_HEADERS_STR  : ${OUTPUT_GRPC_HEADERS_STR}")
    #endif()


    # target_sources(${TARGET} "${OUTPUT_PB_SOURCES_STR}"  )
    # target_sources(${TARGET} "${OUTPUT_PB_HEADERS_STR}"  )
    # target_sources(${TARGET} "${OUTPUT_GRPC_SOURCES_STR}")
    # target_sources(${TARGET} "${OUTPUT_GRPC_HEADERS_STR}")

    # target_sources(${TARGET} "${OUTPUT_PB_SOURCES}"  )
    # target_sources(${TARGET} "${OUTPUT_PB_HEADERS}"  )
    # target_sources(${TARGET} "${OUTPUT_GRPC_SOURCES}")
    # target_sources(${TARGET} "${OUTPUT_GRPC_HEADERS}")

    # target_sources(${TARGET}
    #   "${OUTPUT_PB_SOURCES}"
    #   "${OUTPUT_PB_HEADERS}"
    #   "${OUTPUT_GRPC_SOURCES}"
    #   "${OUTPUT_GRPC_HEADERS}"
    #   )

    foreach(FILE_PB_SRC ${OUTPUT_PB_SOURCES})
        target_sources(${TARGET} PRIVATE ${FILE_PB_SRC})
    endforeach()

    foreach(FILE_PB_HDR ${OUTPUT_PB_HEADERS})
        target_sources(${TARGET} PRIVATE ${FILE_PB_HDR})
    endforeach()

    foreach(FILE_PB_GRPC_SRC ${OUTPUT_GRPC_SOURCES})
        target_sources(${TARGET} PRIVATE ${FILE_PB_GRPC_SRC})
    endforeach()

    foreach(FILE_PB_GRPC_HDR ${OUTPUT_GRPC_HEADERS})
        target_sources(${TARGET} PRIVATE ${FILE_PB_GRPC_HDR})
    endforeach()


    if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_UMBA_ADD_TARGET_PROTOBUF_PROTO_FILES)
        message(STATUS "===============================================")
    endif()

endfunction()

#----------------------------------------------------------------------------
function(umba_add_target_protobuf_grpc_proto_files
         TARGET
         PROTO_FILES_MASK
         FILES_ROOT
        )
    # set(FOO) # Создаём пустую переменную
    # umba_add_target_protobuf_proto_files_ex(${TARGET} ${PROTO_FILES_MASK} ${FOO})
    umba_add_target_protobuf_grpc_proto_files_ex(${TARGET} ${PROTO_FILES_MASK} ${FILES_ROOT} "")
endfunction()

#----------------------------------------------------------------------------
# set(UMBA_USE_BOOST       ON)
# set(UMBA_USE_BOOST_FETCH ON)
# set(UMBA_STATIC_RUNTIME  ON)
# set(UMBA_BOOST_CMAKE_FETCH_URL D:/boost-1.84.0.tar.xz) # https://github.com/boostorg/boost/releases/download/boost-1.84.0/boost-1.84.0.tar.xz #URL_MD5 893b5203b862eb9bbd08553e24ff146a
# https://github.com/boostorg/boost/releases/download/boost-1.85.0/boost-1.85.0-cmake.tar.xz

if (UMBA_USE_BOOST_FETCH)
    set(UMBA_USE_BOOST ON)
    set(UMBA_USE_BOOST ON PARENT_SCOPE)
endif()


if(UMBA_USE_BOOST)

    add_compile_definitions("UMBA_USE_BOOST")

    if(UMBA_USE_BOOST_FETCH)

        if(NOT UMBA_BOOST_CMAKE_FETCH_URL)
            if(DEFINED ENV{BOOST_CMAKE_FETCH_URL})
                set(UMBA_BOOST_CMAKE_FETCH_URL "$ENV{BOOST_CMAKE_FETCH_URL}")
            endif()
        endif()

        if(NOT UMBA_BOOST_CMAKE_FETCH_URL) # https://github.com/boostorg/boost/releases/download/boost-1.84.0/boost-1.84.0.tar.xz
            set(UMBA_BOOST_CMAKE_FETCH_URL  "https://github.com/boostorg/boost/releases/download/boost-1.85.0/boost-1.85.0-cmake.tar.xz")
        endif()

        if(NOT UMBA_BOOST_CMAKE_FETCH_URL)
            message(FATAL_ERROR "UMBA_USE_BOOST_FETCH is set, but UMBA_BOOST_CMAKE_FETCH_URL is not set, nor BOOST_CMAKE_FETCH_URL environment variable. See .cmake/README.md for details how to set up Boost")
        endif()
        
        include(FetchContent)
        FetchContent_Declare(
          Boost
          URL ${UMBA_BOOST_CMAKE_FETCH_URL}
          DOWNLOAD_EXTRACT_TIMESTAMP ON
        )
        FetchContent_MakeAvailable(Boost)
    
    else() # Use local lightweight boost
    
        if(NOT Boost_INCLUDE_DIR)
            if(DEFINED ENV{BOOST_ROOT})
                set(Boost_INCLUDE_DIR "$ENV{BOOST_ROOT}")
            endif()
        endif()

        if(NOT Boost_INCLUDE_DIR)
            message(FATAL_ERROR "UMBA_USE_BOOST is set, but Boost_INCLUDE_DIR is not set, nor BOOST_ROOT environment variable. See .cmake/README.md for details how to set up Boost")
        endif()
    
        if(Boost_INCLUDE_DIR)
            find_package(Boost)
            include_directories(${Boost_INCLUDE_DIRS})
        endif()
    
    endif()

endif()




# https://stackoverflow.com/questions/10113017/setting-the-msvc-runtime-in-cmake
# https://cmake.org/cmake/help/latest/prop_tgt/MSVC_RUNTIME_LIBRARY.html
# set_property(TARGET foo PROPERTY
#  MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
# https://cmake.org/cmake/help/git-stage/variable/CMAKE_MSVC_RUNTIME_LIBRARY.html
# https://cmake.org/cmake/help/git-stage/manual/cmake-generator-expressions.7.html#manual:cmake-generator-expressions(7)
# set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
# MultiThreaded$<$<CONFIG:Debug>:Debug>DLL

# linux
# https://stackoverflow.com/questions/35994339/link-linux-c-application-statically-via-cmake-2-8

#----------------------------------------------------------------------------
include("${CMAKE_CURRENT_LIST_DIR}/umba_runtime_opt_check.cmake")

#----------------------------------------------------------------------------

# if(UMBA_STATIC_RUNTIME)
#     # For use as ${UMBA_STATIC_RUNTIME} when calling umba_add_target_options
#     set(UMBA_STATIC_RUNTIME "UMBA_STATIC_RUNTIME")
#     set(STATIC_RUNTIME      "STATIC_RUNTIME")
#     set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
# else()
#     message("Default Dynamic runtime used")
# endif()


### Boost
# Defaults for Boost
# set(Boost_USE_STATIC_LIBS OFF) 
#set(Boost_USE_MULTITHREADED ON)  
#set(Boost_USE_STATIC_RUNTIME OFF) 


# D:\CMake\share\cmake-3.29\Modules\FindBoost.cmake
# https://cmake.org/cmake/help/latest/module/FindBoost.html
# https://stackoverflow.com/questions/6646405/how-do-you-add-boost-libraries-in-cmakelists-txt

# Install
# https://www.youtube.com/watch?v=D640-ZJmBWM
# How to link C++ program with Boost using CMake - https://stackoverflow.com/questions/3897839/how-to-link-c-program-with-boost-using-cmake
# Using Boost with CMake - https://discourse.cmake.org/t/using-boost-with-cmake/6299
# Работа с Boost и CMake под Windows - https://zhitenev.ru/rabota-s-boost-i-cmake-pod-windows/
# Boost CMake support infrastructure - https://github.com/boostorg/cmake
#   git clone --recurse-submodules https://github.com/boostorg/boost  
# Building and Installing the Library - https://www.boost.org/doc/libs/1_85_0/libs/regex/doc/html/boost_regex/install.html

# Cross-compilation - https://www.boost.org/build/doc/html/bbv2/tasks/crosscompile.html
# Builtin tools - https://www.boost.org/build/doc/html/bbv2/reference/tools.html
# Or, Build Custom Binaries - https://www.boost.org/doc/libs/1_56_0/more/getting_started/unix-variants.html#or-build-custom-binaries

# How do I use a different compiler - https://gitlab.kitware.com/cmake/community/-/wikis/FAQ#how-do-i-use-a-different-compiler
# #set(CMAKE_CXX_LINK_EXECUTABLE ${CMAKE_CXX}) # не нужно
# set(CMAKE_LINKER ${CMAKE_CXX})



# STATIC_LIBS
# MULTITHREADED - no mean, option is set to ON by default
# SINGLETHREADED - single threaded not supported by MSVC?
# STATIC_RUNTIME
function(umba_configure_boost)

    math(EXPR maxArgN "${ARGC} - 1")

    foreach(_index RANGE 0 ${maxArgN} 1)

        set(CURARG ${ARGV${_index}})

        if(NOT CURARG)
            message("umba_configure_boost: NULL Argument at pos: ${_index} (${CURARG}) (1)")
            continue()
        endif()

        if(${CURARG} STREQUAL "")
            message("umba_configure_boost: NULL Argument at pos: ${_index} (${CURARG}) (2)")
            continue()
        endif()

        if(${CURARG} STREQUAL "STATIC_LIBS" OR ${CURARG} STREQUAL "UMBA_STATIC_LIBS")
            set(Boost_USE_STATIC_LIBS ON) 
        elseif(${CURARG} STREQUAL "MULTITHREADED")
            # no mean, option is set to ON by default
        elseif(${CURARG} STREQUAL "SINGLETHREADED")
            set(Boost_USE_MULTITHREADED OFF)  
        elseif(${CURARG} STREQUAL "STATIC_RUNTIME" OR ${CURARG} STREQUAL "UMBA_STATIC_RUNTIME")
            set(Boost_USE_STATIC_RUNTIME ON) 
        endif()

    endforeach()

endfunction()


### Trees

function(umba_make_sources_tree SRC_ROOT SRCS HDRS RCSRCS)

    if(SRCS)
        source_group(TREE ${SRC_ROOT} PREFIX "Source Files" FILES ${SRCS})
    endif()

    if(HDRS)
        source_group(TREE ${SRC_ROOT} PREFIX "Header Files" FILES ${HDRS})
    endif()

    if(RCSRCS)
        source_group(TREE ${SRC_ROOT} PREFIX "Resource Files" FILES ${RCSRCS})
    endif()

endfunction()




### Target options

# UNICODE/MBCS/DBCS
# https://learn.microsoft.com/ru-ru/cpp/text/support-for-multibyte-character-sets-mbcss?view=msvc-170
# https://learn.microsoft.com/ru-ru/cpp/text/mbcs-support-in-visual-cpp?view=msvc-170
# https://learn.microsoft.com/ru-ru/cpp/text/mbcs-programming-tips?view=msvc-170

# "UNICODE" "CONSOLE" "WINDOWS" "BIGOBJ" "UTF8"
# "SRCUTF8"/"UTF8SRC"/"SRC_UTF8"/"UTF8_SRC"
# "STATIC_RUNTIME"
function(umba_add_target_options TARGET)

    # https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html

    # https://jeremimucha.com/2021/02/cmake-functions-and-macros/

    #math(EXPR indices "${ARGC} - 1")
    #foreach(_index RANGE ${indices})

    math(EXPR maxArgN "${ARGC} - 1")
    foreach(_index RANGE 1 ${maxArgN} 1)

        set(CURARG ${ARGV${_index}})

        if(NOT CURARG)
            message("umba_add_target_options: NULL Argument at pos: ${_index} (${CURARG}) (1)")
            continue()
        endif()

        if(${CURARG} STREQUAL "")
            message("umba_add_target_options: NULL Argument at pos: ${_index} (${CURARG}) (2)")
            continue()
        endif()

        if(${CURARG} STREQUAL "UNICODE")

            # Common for all
            target_compile_definitions(${TARGET} PRIVATE "UNICODE" "_UNICODE")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                message(NOTICE "Add UNICODE options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                target_compile_options(${TARGET} PRIVATE "-municode")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                message(NOTICE "Add UNICODE options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                #message(NOTICE "Add UNICODE options for MSVC")

            endif()

        elseif(${CURARG} STREQUAL "SRCUTF8" OR ${CURARG} STREQUAL "UTF8SRC" OR ${CURARG} STREQUAL "UTF8_SRC" OR ${CURARG} STREQUAL "SRC_UTF8")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                message(NOTICE "Add SRCUTF8 options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                # !!! conversion from UTF-8 to UTF-8 -finput-charset=UTF-8 not supported by iconv
                # target_compile_options(${TARGET} PRIVATE "-finput-charset=UTF-8")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                message(NOTICE "Add SRCUTF8 options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                # /utf-8, that sets both /source-charset:utf-8 and /execution-charset:utf-8.
                target_compile_options(${TARGET} PRIVATE "/source-charset:utf-8")

            endif()

        elseif(${CURARG} STREQUAL "UTF8")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                message(NOTICE "Add UTF8 options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                # !!! conversion from UTF-8 to UTF-8 -finput-charset=UTF-8 not supported by iconv
                # target_compile_options(${TARGET} PRIVATE "-fexec-charset=UTF-8 -finput-charset=UTF-8")  # https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                message(NOTICE "Add UTF8 options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                target_compile_options(${TARGET} PRIVATE "/utf-8")

            endif()

        elseif(${CURARG} STREQUAL "CONSOLE")
            if(WIN32)

                # Common for all
                target_compile_definitions(${TARGET} PRIVATE "CONSOLE" "_CONSOLE")

                if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                    message(NOTICE "Add CONSOLE options for Clang")

                elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                    target_compile_options(${TARGET} PRIVATE "-mconsole")
                    target_link_options(${TARGET} PRIVATE "-Wl,--subsystem,console")

                elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                    message(NOTICE "Add CONSOLE options for Intel")

                elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                    target_link_options(${TARGET} PRIVATE "/SUBSYSTEM:CONSOLE")

                endif()
            endif()

        elseif(${CURARG} STREQUAL "WINDOWS")
            if(WIN32)

                # Common for all
                target_compile_definitions(${TARGET} PRIVATE "WINDOWS" "_WINDOWS")

                if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                    message(NOTICE "Add WINDOWS options for Clang")

                elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                    target_compile_options(${TARGET} PRIVATE "-mwindows")
                    target_link_options(${TARGET} PRIVATE "-Wl,--subsystem,windows")

                elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                    message(NOTICE "Add WINDOWS options for Intel")

                elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                    target_link_options(${TARGET} PRIVATE "/SUBSYSTEM:WINDOWS")

                endif()
            endif()

        elseif(${CURARG} STREQUAL "BIGOBJ")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                message(NOTICE "Add BIGOBJ options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                target_compile_options(${TARGET} PRIVATE "-Wa,-mbig-obj" "-Wl,--large-address-aware")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                message(NOTICE "Add BIGOBJ options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                target_compile_options(${TARGET} PRIVATE "/bigobj")

            endif()

        elseif(${CURARG} STREQUAL "G0")
            if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
                target_compile_options(${TARGET} PRIVATE "-g0")
            endif()

        elseif(${CURARG} STREQUAL "G1")
            if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
                target_compile_options(${TARGET} PRIVATE "-g1")
            endif()

        elseif(${CURARG} STREQUAL "G3")
            if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
                target_compile_options(${TARGET} PRIVATE "-g3")
            endif()

        elseif(${CURARG} STREQUAL "WALL")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                #message(NOTICE "Add WALL options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                # https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
                target_compile_options(${TARGET} PRIVATE "-Wall" "-Wextra" "-Wimplicit-fallthrough" "-Wreturn-type")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                #message(NOTICE "Add WALL options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                # https://devblogs.microsoft.com/cppblog/broken-warnings-theory/
                # https://habr.com/ru/companies/pvs-studio/articles/347686/
                # https://learn.microsoft.com/en-us/cpp/build/reference/compiler-option-warning-level?view=msvc-170
                target_compile_options(${TARGET} PRIVATE "/Wall" "/external:anglebrackets" "/external:W1")

            endif()

        elseif(${CURARG} STREQUAL "PEDANTIC") # includes "WALL" options too

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                #message(NOTICE "Add PEDANTIC options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                # https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
                target_compile_options(${TARGET} PRIVATE "-Wpedantic" "-pedantic" "-Werror=pedantic" "-pedantic-errors" "-Wall" "-Wextra" "-Wreturn-type")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                #message(NOTICE "Add PEDANTIC options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                # https://devblogs.microsoft.com/cppblog/broken-warnings-theory/
                # https://habr.com/ru/companies/pvs-studio/articles/347686/
                # https://learn.microsoft.com/en-us/cpp/build/reference/compiler-option-warning-level?view=msvc-170
                # https://learn.microsoft.com/en-us/cpp/build/reference/za-ze-disable-language-extensions?view=msvc-160
                # https://learn.microsoft.com/en-us/cpp/build/reference/zc-conformance?view=msvc-170
                # https://stackoverflow.com/questions/69575307/microsoft-c-c-what-is-the-definition-of-strict-conformance-w-r-t-implement
                target_compile_options(${TARGET} PRIVATE "/Wall" "/permissive-" "/external:anglebrackets" "/external:W0")
                # Вопрос - внешние варнинги будут как ошибки при /WX?

            endif()

        elseif(${CURARG} STREQUAL "PERMISSIVE")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                #message(NOTICE "Add PERMISSIVE options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                # https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
                target_compile_options(${TARGET} PRIVATE "-fpermissive" )

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                #message(NOTICE "Add PERMISSIVE options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                # https://devblogs.microsoft.com/cppblog/broken-warnings-theory/
                # https://habr.com/ru/companies/pvs-studio/articles/347686/
                # https://learn.microsoft.com/en-us/cpp/build/reference/compiler-option-warning-level?view=msvc-170
                target_compile_options(${TARGET} PRIVATE "/W2" "/permissive" "/external:anglebrackets" "/external:W0")

            endif()

        elseif(${CURARG} STREQUAL "NOWARNPACKALIGN")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                #message(NOTICE "Add NOWARNPACKALIGN options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                #message(NOTICE "Add NOWARNPACKALIGN options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                #message(NOTICE "Add NOWARNPACKALIGN options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                target_compile_options(${TARGET} PRIVATE "/wd4315")

            endif()

        elseif(${CURARG} STREQUAL "WERR" OR ${CURARG} STREQUAL "WERROR")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                #message(NOTICE "Add WERR options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                # https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html

                target_compile_options(${TARGET} PRIVATE "-Werror" -Werror=return-type)

                # typedef locally defined but not used
                target_compile_options(${TARGET} PRIVATE "-Wno-unused-local-typedefs")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                #message(NOTICE "Add WERR options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                # https://learn.microsoft.com/ru-ru/cpp/build/reference/permissive-standards-conformance?view=msvc-170
                # https://learn.microsoft.com/en-us/cpp/build/reference/permissive-standards-conformance?view=msvc-170
                # https://learn.microsoft.com/en-us/cpp/build/reference/compiler-option-warning-level?view=msvc-170

                target_compile_options(${TARGET} PRIVATE "/WX" "/external:anglebrackets" "/external:W0")

                # !!! Надо разобратся со всеми этими варнингами. Пока дизаблим

                # warning C4435: 'TYPE': Object layout under /vd2 will change due to virtual base 'TYPE_BASE'
                target_compile_options(${TARGET} PRIVATE "/wd4435")

                # warning C4464: exclude warning "relative include path contains '..'"
                target_compile_options(${TARGET} PRIVATE "/wd4464")

                # warning C4505: unreferenced function has been removed
                target_compile_options(${TARGET} PRIVATE "/wd4514")

                # warning C4514: unreferenced inline function has been removed
                target_compile_options(${TARGET} PRIVATE "/wd4514")

                # warning C4626: 'TYPE': assignment operator was implicitly defined as deleted
                target_compile_options(${TARGET} PRIVATE "/wd4626")

                # https://learn.microsoft.com/en-us/cpp/error-messages/compiler-warnings/compiler-warning-level-4-c4710?view=msvc-170
                # warning C4710: function not inlined
                target_compile_options(${TARGET} PRIVATE "/wd4710")

                # warning C4711: function selected for automatic inline expansion
                target_compile_options(${TARGET} PRIVATE "/wd4711")

                # warning C4738: storing 32-bit float result in memory, possible loss of performance
                target_compile_options(${TARGET} PRIVATE "/wd4738")

                # warning C4810: value of pragma pack(show)
                # target_compile_options(${TARGET} PRIVATE "/wd4810")
                
                # warning C4820: N bytes padding added after data member 'memberName'
                target_compile_options(${TARGET} PRIVATE "/wd4820")

                # warning C4866: compiler may not enforce left-to-right evaluation order for call to 'umba::SimpleFormatter::operator<<<std::basic_string<char,std::char_traits<char>,std::allocator<char> > >'
                target_compile_options(${TARGET} PRIVATE "/wd4866")

                # warning C5027: 'TYPE': move assignment operator was implicitly defined as deleted
                target_compile_options(${TARGET} PRIVATE "/wd5027")

                # warning C5045: Compiler will insert Spectre mitigation for memory load if /Qspectre switch specified
                target_compile_options(${TARGET} PRIVATE "/wd5045")

            endif()

        elseif(${CURARG} STREQUAL "ALLOW_UNUSED")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                message(NOTICE "Add ALLOW_UNUSED options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                target_compile_options(${TARGET} PRIVATE "-Wno-unused-parameter")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                message(NOTICE "Add ALLOW_UNUSED options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                target_compile_options(${TARGET} PRIVATE "/wd4100")

            endif()

        elseif(${CURARG} STREQUAL "STATIC_RUNTIME" OR ${CURARG} STREQUAL "UMBA_STATIC_RUNTIME")
            if(WIN32)

                # Под винду разве не все компиляторы используют MSVC ABI?
                set_property(TARGET ${TARGET} PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

                #if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
                #    message(NOTICE "Add STATIC_RUNTIME options for Clang")
                #elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
                #    target_compile_options(${TARGET} PRIVATE "-Wa,-mbig-obj")
                #elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
                #    message(NOTICE "Add STATIC_RUNTIME options for Intel")
                #elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
                #    set_property(TARGET ${TARGET} PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
                #endif()

            endif()

        elseif(${CURARG} STREQUAL "PLIBS" OR ${CURARG} STREQUAL "PLATFORM_LIBS") # basic platform libs
            if(WIN32) # target is Win32, not host (CMAKE_HOST_WIN32)
                      # https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html

                target_link_libraries(${TARGET} PRIVATE user32 gdi32 kernel32 ws2_32 advapi32 dbghelp iphlpapi shell32)

            endif()

        endif() # if(${CURARG}

    endforeach()

endfunction()



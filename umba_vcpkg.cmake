# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Поддержка VCPKG
# ----------------------------------------------------------------

include_guard(GLOBAL)

include("${CMAKE_CURRENT_LIST_DIR}/functions_base.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/pathlib.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/strlib.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/umba_system_arch.cmake")


#----------------------------------------------------------------------------
#[===[.md:

UMBA_STATIC_RUNTIME - при необходимости должна быть установлена в TRUE до подключения данного файла
BUILD_SHARED_LIBS   - при необходимости должна быть установлена в TRUE до подключения данного файла
UMBA_VCPKG_TARGET_TRIPLET_PREFIXES - список кастомных префиксов для target триплетов

# Переменные инициализации VCPKG: Все переменные управления vcpkg (например, VCPKG_TARGET_TRIPLET, VCPKG_MANIFEST_MODE) должны быть установлены до вызова include.

- VCPKG_HOST_TRIPLET: определяет триплет для инструментов, которые должны запускаться на вашей текущей машине (например, генераторы кода, такие как protobuf или bison).

- VCPKG_TARGET_TRIPLET

- VCPKG_INSTALLED_DIR: задает путь, куда vcpkg будет устанавливать библиотеки. В режиме манифеста по умолчанию это ${CMAKE_BINARY_DIR}/vcpkg_installed.

- VCPKG_CHAINLOAD_TOOLCHAIN_FILE: критически важна для кросс-компиляции. Позволяет vcpkg загрузить ваш основной файл тулчейна (с компиляторами) после настройки своей среды. 

- VCPKG_MANIFEST_DIR: позволяет указать альтернативный путь к папке с файлом vcpkg.json, если он лежит не в корне проекта.

- VCPKG_MANIFEST_FEATURES: список дополнительных функций (features) из манифеста, которые нужно включить (например, set(VCPKG_MANIFEST_FEATURES "tests;examples")).

- VCPKG_OVERLAY_PORTS: список путей к вашим собственным (кастомным) портам библиотек.

- VCPKG_OVERLAY_TRIPLETS: список путей к вашим кастомным триплетам.

- VCPKG_INSTALL_OPTIONS: дополнительные флаги командной строки, которые будут переданы команде vcpkg install (например, для настройки бинарного кэширования).

- VCPKG_USE_HOST_TOOLS: при значении ON автоматически добавляет исполняемые файлы, собранные под HOST_TRIPLET, в путь поиска CMAKE_PROGRAM_PATH. 

- set(VCPKG_POLICY_ALLOW_OBSOLETE_MSVCRT enabled) - для подавления варнингов при сборке триплетом (x64-)mingw-dynamic

#]===]
#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
#[===[.md:

  WIN32, APPLE, UNIX, CYGWIN, MSYS, ANDROID, IOS, ..
 
  Variables that Describe the System - https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html#variables-that-describe-the-system
  MSVC_VERSION - https://cmake.org/cmake/help/latest/variable/MSVC_VERSION.html#variable:MSVC_VERSION
  MSVC_TOOLSET_VERSION - https://cmake.org/cmake/help/latest/variable/MSVC_TOOLSET_VERSION.html#variable:MSVC_TOOLSET_VERSION

#]===]
#----------------------------------------------------------------------------


#----------------------------------------------------------------------------
# Check for environment variable VCPKG_ROOT
if(DEFINED ENV{VCPKG_ROOT})

    set(UMBA_VCPKG_ROOT $ENV{VCPKG_ROOT})
    umba_path_normalize(UMBA_VCPKG_ROOT ${UMBA_VCPKG_ROOT})

    set(UMBA_VCPKG_CMAKE "${UMBA_VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")

    if(EXISTS "${UMBA_VCPKG_CMAKE}")
        set(UMBA_VCPKG_FOUND ON)
    endif()
  
    if (UMBA_VCPKG_FOUND AND UMBA_CMAKE_VERBOSE)
        message(STATUS "UMBA: Found VCPKG: ${UMBA_VCPKG_ROOT}") # NOTICE
        message(STATUS "UMBA: vcpkg.cmake: ${UMBA_VCPKG_CMAKE}") # NOTICE
    endif()

endif()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
#[===[

VCPKG_OVERLAY_TRIPLETS - переменная окружения, используется такая же переменная CMake'а

Приоритет поиска:
- Триплеты из VCPKG_OVERLAY_TRIPLETS (в порядке указания)
- Стандартные триплеты vcpkg (<vcpkg-root>/triplets/)
- Сообщество триплетов (<vcpkg-root>/triplets/community/)

Наверное, надо добавить поиск триплетов в переменной окружения VCPKG_OVERLAY_TRIPLETS вторым шагом, чтобы не задавать всегда явно.
CMake-переменная VCPKG_OVERLAY_TRIPLETS явно задаётся при сборке из командной строки, так что она имеет приоритет на переменной окружения.

Нам это нужно, чтобы проверять доступность триплетов, которые мы создадим сами

#]===]

function(umba_vcpkg_get_all_triplet_paths OUTPUT_VAR )

    umba_path_split_pathlist(VCPKG_OVERLAY_TRIPLETS_PATH_LIST "${VCPKG_OVERLAY_TRIPLETS}")
    # list(APPEND umbaRes "${VCPKG_OVERLAY_TRIPLETS_PATH_LIST}")
    foreach(P ${VCPKG_OVERLAY_TRIPLETS_PATH_LIST})
        umba_path_normalize(umbaTmp ${P})
        list(APPEND umbaRes ${umbaTmp})
    endforeach()

    # if (UMBA_CMAKE_VERBOSE)
    #     message(STATUS "VCPKG_OVERLAY_TRIPLETS var paths: ${VCPKG_OVERLAY_TRIPLETS_PATH_LIST}")
    #     foreach(PATH ${VCPKG_OVERLAY_TRIPLETS_PATH_LIST})
    #         message(STATUS "  ${PATH}")
    #     endforeach()
    # endif()
    # message(STATUS "Env VCPKG_OVERLAY_TRIPLETS var paths: $ENV{VCPKG_OVERLAY_TRIPLETS}")

    umba_path_split_pathlist_env_var(ENV_VCPKG_OVERLAY_TRIPLETS_PATH_LIST VCPKG_OVERLAY_TRIPLETS)
    # list(APPEND umbaRes "${ENV_VCPKG_OVERLAY_TRIPLETS_PATH_LIST}")
    foreach(P ${ENV_VCPKG_OVERLAY_TRIPLETS_PATH_LIST})
        umba_path_normalize(umbaTmp ${P})
        list(APPEND umbaRes ${umbaTmp})
    endforeach()

    # if (UMBA_CMAKE_VERBOSE)
    #     message(STATUS "Env VCPKG_OVERLAY_TRIPLETS var paths: ${ENV_VCPKG_OVERLAY_TRIPLETS_PATH_LIST}")
    #     foreach(PATH ${ENV_VCPKG_OVERLAY_TRIPLETS_PATH_LIST})
    #         message(STATUS "  ${PATH}")
    #     endforeach()
    # endif()

    if (UMBA_VCPKG_FOUND)

        list(APPEND umbaRes "${UMBA_VCPKG_ROOT}/triplets")
        list(APPEND umbaRes "${UMBA_VCPKG_ROOT}/triplets/community")

    endif()

    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)

endfunction()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
umba_vcpkg_get_all_triplet_paths(UMBA_VCPKG_TRIPLETS_PATH_LIST)

if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_VCPKG)
    message(STATUS "UMBA: UMBA_VCPKG_TRIPLETS_PATH_LIST: ${UMBA_VCPKG_TRIPLETS_PATH_LIST}")
    foreach(PATH ${UMBA_VCPKG_TRIPLETS_PATH_LIST})
        message(STATUS "  ${PATH}")
    endforeach()
endif()

#----------------------------------------------------------------------------
if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_VCPKG)
    # message(STATUS "CMAKE_HOST_SYSTEM_NAME     : ${CMAKE_HOST_SYSTEM_NAME}")
    # message(STATUS "CMAKE_HOST_SYSTEM_PROCESSOR: ${CMAKE_HOST_SYSTEM_PROCESSOR}")
    # #message(STATUS ": ${}")
endif()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
# Тут пошла жара
#----------------------------------------------------------------------------
#[===[

Существуют триплеты вида:

  arm-android.cmake
  arm-neon-android.cmake
  arm-ios.cmake
  arm-linux.cmake
  arm-mingw-dynamic.cmake
  arm-uwp.cmake
  arm-watchos.cmake
  arm-windows.cmake
  arm64-freebsd.cmake
  arm64-osx-dynamic.cmake
  arm64-tvos.cmake
  arm64-visionos.cmake
  arm64-watchos.cmake
  wasm32-emscripten.cmake
  x64-netbsd.cmake
  x64-openbsd.cmake
  x64-solaris.cmake
  x64-xbox-scarlett.cmake

  Триплеты: ARCH-PLATFORM-LINKAGE[-CRT][-USER_SUFFIX]


Триплеты состоят из трёх частей (разделяемых знаком минус):
- архитектура: arm/arm64/x86/x64/stm32/riscv32/riscv64/s390x/wasm32/etc;
- система: linux/freebsd/netbsd/openbsd/solaris/xbox/visionos/watchos/watchos-simulator/tvos/tvos-simulator/windows/uwp/mingw/osx/ios/android/neon-android/emscripten;
- тип библиотек: static/dynamic. Тип сборки библиотек по умолчанию, как я понимаю.
    Данная часть - опциональная, вроде как. Хотя, для Windows есть только static; dynamic - нет, и без static/dynamic вообще тоже нет версии.

Дополнительно, для некоторых систем может использоваться суффикс '-release' - для сборки релиза?
  arm64-windows-static-release.cmake

Дополнительно, для некоторых систем может использоваться суффикс '-md' - dynamic CRT (uwp/windows)
  arm-uwp-static-md.cmake

Могут использоваться оба: x64-windows-static-md-release.cmake

UMBA_STATIC_RUNTIME - отвечает как раз за то, какая CRT используется, '-md' суффикс
BUILD_SHARED_LIBS - Tell add_library() to default to SHARED libraries, instead of STATIC libraries, when called with no explicit library type.
  https://cmake.org/cmake/help/latest/variable/BUILD_SHARED_LIBS.html
  Это отвечает (имхо) за static/dynamic

arm64-mingw-dynamic.cmake
arm64-mingw-static.cmake
arm64-uwp-static-md.cmake


До подключения vcpkg.cmake нам надо настроить следующие переменные:
- VCPKG_HOST_TRIPLET
- VCPKG_TARGET_TRIPLET

Но, вообще-то, VCPKG_HOST_TRIPLET нам не особенно нужен для vcpkg.cmake

Либы у нас устанавливаются либо:
 - с дефолтным хостовым триплетом
 - с тем же хостовым триплетом, что и target, когда и хост и таргет одинаковы
 - хостовый и целевой триплеты различны - кросс-компиляция (STM32/RISCV32/etc)

CMAKE_CROSSCOMPILING - ON при кросс-компиляции, когда где-то CMAKE_SYSTEM_NAME
устанавливается ручками, явно, в тулчейн-файле, или ещё где-то.


Итого:
  - делаем основной префикс из ${UMBA_TARGET_ARCH}-${UMBA_TARGET_SYSTEM} - UMBA_VCPKG_SYSARCH_PREFIX
  - проверяем наличие ${UMBA_VCPKG_SYSARCH_PREFIX}-[static|dymamic] (BUILD_SHARED_LIBS), добавляя -md, если NOT UMBA_STATIC_RUNTIME


Как задать статический рантайм
MSVC 
для TARGET
    set_property(TARGET your_target_name PROPERTY 
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
    )
глобально
    cmake_minimum_required(VERSION 3.15) # Required for this variable/property to work
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

Для GCC, Clang, и MinGW
для TARGET
    target_link_options(your_target_name PRIVATE 
        "-static-libgcc" 
        "-static-libstdc++"
    )
To try and link everything possible statically
    target_link_options(your_target_name PRIVATE 
        "-static"
        "-static-libgcc" 
        "-static-libstdc++"
    )

#]===]

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
include("${CMAKE_CURRENT_LIST_DIR}/umba_runtime_opt_check.cmake")

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
set(UMBA_VCPKG_SYSARCH_PREFIX "${UMBA_TARGET_ARCH}-${UMBA_TARGET_SYSTEM}")
# !!!
message(STATUS "UMBA_VCPKG_SYSARCH_PREFIX: ${UMBA_VCPKG_SYSARCH_PREFIX}")

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
function(umba_vcpkg_check_triplet_cmake_exist FOUND_FULL_FILENAME TRIPLET)

    set(${FOUND_FULL_FILENAME} FALSE PARENT_SCOPE)

    foreach(PATH ${UMBA_VCPKG_TRIPLETS_PATH_LIST})

        set(FILENAME_TO_CHECK "${PATH}/${TRIPLET}.cmake")

        message(STATUS "UMBA: umba_vcpkg_check_triplet_cmake_exist: checking ${FILENAME_TO_CHECK}")

        if(EXISTS "${FILENAME_TO_CHECK}")
            set(${FOUND_FULL_FILENAME} "${FILENAME_TO_CHECK}" PARENT_SCOPE)
            break()
        endif()

    endforeach()

endfunction()

#----------------------------------------------------------------------------
function(umba_vcpkg_find_target_triplet FOUND_TRIPLET FOUND_FULL_FILENAME )

    set(FOUND_TRIPLET FALSE PARENT_SCOPE)
    set(FOUND_FULL_FILENAME FALSE PARENT_SCOPE)

    #---------------------------
    # UMBA_VCPKG_SYSARCH_PREFIX имеет вид: x64-mingw


    #---------------------------
    # Создаём список static/dymamic
    #
    if (BUILD_SHARED_LIBS)
        list(APPEND STATIC_DYNAMIC_LIST "dymamic")
    else()
        list(APPEND STATIC_DYNAMIC_LIST "static")
    endif()

    list(APPEND STATIC_DYNAMIC_LIST "-") # Добавляем пустой элемент, чтобы список никогда не был пустым


    #---------------------------
    # Создаём список суффиксов, которые задают тип C/C++ рантайма
    #
    if (UMBA_MSVC) # Используется MSVC
        if (NOT UMBA_STATIC_RUNTIME)
            list(APPEND RUNTIME_SUFFIX_LIST "md")
        endif()
    endif()

    list(APPEND RUNTIME_SUFFIX_LIST "-") # Добавляем пустой элемент, чтобы список никогда не был пустым


    #---------------------------
    # Формируем список кандидатов
    #
    # Во внешнем цикле перебираем список static/dymamic
    #
    foreach(SHARED_DYNAMIC ${STATIC_DYNAMIC_LIST})

        # Если у нас пустой элемент, то добавляем базу в список и всё
        if ("${SHARED_DYNAMIC}" STREQUAL "-")
            list(APPEND TRIPLET_CANDY_TMP_LIST "${UMBA_VCPKG_SYSARCH_PREFIX}")
            continue()
        endif()

        # Элемент не пустой, к базе добавляем префикс static/dymamic
        set(TRIPLET_CANDY1 "${UMBA_VCPKG_SYSARCH_PREFIX}-${SHARED_DYNAMIC}")

        # Перебираем суффиксы типа рантайма
        foreach(RUNTIME_SUFFIX ${RUNTIME_SUFFIX_LIST})

            # При пустом суффиксе просто добавляем в список базу
            if ("${RUNTIME_SUFFIX}" STREQUAL "-")
                list(APPEND TRIPLET_CANDY_TMP_LIST "${TRIPLET_CANDY1}")
                continue()
            endif()

            list(APPEND TRIPLET_CANDY_TMP_LIST "${TRIPLET_CANDY1}-${RUNTIME_SUFFIX}")

        endforeach()

    endforeach()


    #---------------------------
    # Есть временный список кандидатов
    #
    # Добавляем юзер дефайнед префиксы
    #
    foreach(TRIPLET_CANDY_TMP  ${TRIPLET_CANDY_TMP_LIST})
        foreach(CUSTOM_PREFIX  ${UMBA_VCPKG_TARGET_TRIPLET_PREFIXES})
            list(APPEND TRIPLET_CANDY_LIST "${CUSTOM_PREFIX}-${TRIPLET_CANDY_TMP}")
        endforeach()
    endforeach()

    # Добавляем кандидатов без пользовательского префикса
    foreach(TRIPLET_CANDY_TMP  ${TRIPLET_CANDY_TMP_LIST})
        list(APPEND TRIPLET_CANDY_LIST "${TRIPLET_CANDY_TMP}")
    endforeach()


    #---------------------------
    # Выводим список кандидатов
    if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_VCPKG)
        message(STATUS "UMBA: Target triplet candidates:") # NOTICE
        foreach(TRIPLET_CANDY ${TRIPLET_CANDY_LIST})
            message(STATUS "  ${TRIPLET_CANDY}") # NOTICE
        endforeach()
    endif()


    #---------------------------
    # Итерируемся по списку кандидатов, ищем существующий в каталогах с триплетами
    # args FOUND_TRIPLET FOUND_FULL_FILENAME
    foreach(TRIPLET_CANDY ${TRIPLET_CANDY_LIST})

        umba_vcpkg_check_triplet_cmake_exist(TRIPLET_FULL_FILENAME ${TRIPLET_CANDY})
        message(STATUS "UMBA: checking ${TRIPLET_CANDY} TRIPLET_FULL_FILENAME: ${TRIPLET_FULL_FILENAME}")

        if (TRIPLET_FULL_FILENAME)

            set(${FOUND_TRIPLET} "${TRIPLET_CANDY}" PARENT_SCOPE)
            set(${FOUND_FULL_FILENAME} "${TRIPLET_FULL_FILENAME}" PARENT_SCOPE)

            break()

        endif()

    endforeach()
endfunction()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
umba_vcpkg_find_target_triplet(VCPKG_TARGET_TRIPLET VCPKG_TARGET_TRIPLET_FULL_FILENAME)

# message(STATUS "UMBA: Target triplet: ${VCPKG_TARGET_TRIPLET}")
# message(STATUS "UMBA: Target triplet file : ${VCPKG_TARGET_TRIPLET_FULL_FILENAME}")


if (VCPKG_TARGET_TRIPLET AND UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_VCPKG)
    message(STATUS "UMBA: Found target triplet: ${VCPKG_TARGET_TRIPLET}")
    message(STATUS "UMBA: Target triplet file : ${VCPKG_TARGET_TRIPLET_FULL_FILENAME}")
else()
    message(FATAL_ERROR "UMBA: Target triplet not found")
endif()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
if (UMBA_VCPKG_FOUND)

    # Запихиваем все пути к тирплетам в VCPKG переменную обратно
    set(VCPKG_OVERLAY_TRIPLETS ${UMBA_VCPKG_TRIPLETS_PATH_LIST}) 
    # set(VCPKG_TARGET_TRIPLET ) # уже установлен

    if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_VCPKG)
        message(STATUS "UMBA: including vcpkg.cmake: ${UMBA_VCPKG_CMAKE}")
    endif()

    include("${UMBA_VCPKG_CMAKE}")

endif()

#----------------------------------------------------------------------------



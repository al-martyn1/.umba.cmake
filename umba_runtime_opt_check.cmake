# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Проверка опций, отвечающих за рантайм целевых приложений
# ----------------------------------------------------------------

include_guard(GLOBAL)

#----------------------------------------------------------------------------
# Если тип рантайма не настроен, задаём его

# Проверяем настройки типа рантайма
if (UMBA_DYNAMIC_RUNTIME AND UMBA_STATIC_RUNTIME)
    message(FATAL_ERROR "Option UMBA_DYNAMIC_RUNTIME conflicts with option UMBA_STATIC_RUNTIME")
endif()

if (UMBA_DYNAMIC_RUNTIME)
    set(UMBA_STATIC_RUNTIME FALSE)
    message(STATUS "UMBA: Option UMBA_DYNAMIC_RUNTIME is ON, clear UMBA_STATIC_RUNTIME")
endif()

if (UMBA_STATIC_RUNTIME)
    set(UMBA_DYNAMIC_RUNTIME FALSE)
    message(STATUS "UMBA: Option UMBA_STATIC_RUNTIME is ON, clear UMBA_DYNAMIC_RUNTIME")
endif()

if (NOT UMBA_DYNAMIC_RUNTIME AND NOT UMBA_STATIC_RUNTIME)
    set(UMBA_STATIC_RUNTIME TRUE)
endif()



umba_early_detection_check_for_target_msvc_sln(UMBA_ED_IS_MSVS_SLN)
# message(STATUS "UMBA: CMAKE_CXX_COMPILER_ID: ${CMAKE_CXX_COMPILER_ID}")

#if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
#    set(IS_MSVC_CL TRUE)
#elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_SIMULATE_ID STREQUAL "MSVC")
#    set(IS_CLANG_CL TRUE)   # clang-cl, совместим с MSVC
#elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND (MINGW OR MSYS))
#    set(IS_CLANG_MINGW TRUE)  # Clang в режиме MinGW
#elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
#    set(IS_GCC_MINGW TRUE)
#endif()

if(UMBA_ED_IS_MSVS_SLN OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_SIMULATE_ID STREQUAL "MSVC"))
    if (UMBA_STATIC_RUNTIME)
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    else()
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
    endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    if (UMBA_STATIC_RUNTIME)
        add_link_options(-static-libgcc -static-libstdc++)
    endif()
endif()

# -static-libgcc, -static-libstdc++

# umba_early_detection_check_for_target_msvc_sln OUTPUT_VAR)

#----------------------------------------------------------------------------

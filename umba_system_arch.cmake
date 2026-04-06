# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Детект системы и архитектуры
# ----------------------------------------------------------------

cmake_minimum_required(VERSION 3.25)

include_guard(GLOBAL)

include("${CMAKE_CURRENT_LIST_DIR}/ed_detect_mingw.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/ed_detect_msvc.cmake")

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
if (UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_HOST_TARGET)
    # message(STATUS "CMAKE_HOST_SYSTEM_NAME     : ${CMAKE_HOST_SYSTEM_NAME}")
    # message(STATUS "CMAKE_HOST_SYSTEM_VERSION  : ${CMAKE_HOST_SYSTEM_VERSION}")
    # message(STATUS "CMAKE_HOST_SYSTEM_PROCESSOR: ${CMAKE_HOST_SYSTEM_PROCESSOR}")
    # message(STATUS "CMAKE_HOST_SYSTEM          : ${CMAKE_HOST_SYSTEM}")
    # message(STATUS "MINGW                      : ${MINGW}")
    # message(STATUS "CMAKE_GENERATOR            : ${CMAKE_GENERATOR}")
    # message(STATUS "CMAKE_GENERATOR_PLATFORM   : ${CMAKE_GENERATOR_PLATFORM}")
    # message(STATUS "CMAKE_VS_PLATFORM_NAME     : ${CMAKE_VS_PLATFORM_NAME}")
    # message(STATUS "CMAKE_C_COMPILER           : ${CMAKE_C_COMPILER}")
endif()
#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
# Detect MSVC target

if (NOT UMBA_TARGET_ARCH)
    umba_early_detection_check_for_target_msvc_sln(umbaTmp_isTargetMsvcSln)
    if (umbaTmp_isTargetMsvcSln)
        umba_early_detection_check_for_target_arch_msvc_sln(UMBA_TARGET_ARCH)
        set(UMBA_TARGET_SYSTEM "windows")
        set(UMBA_MSVC TRUE)
    endif()
    if (UMBA_TARGET_ARCH AND UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_HOST_TARGET)
        message(STATUS "UMBA: Autodetected MSVC sln(x) mode")
        message(STATUS "UMBA: Autodetected UMBA_TARGET_SYSTEM: ${UMBA_TARGET_SYSTEM}")
        message(STATUS "UMBA: Autodetected UMBA_TARGET_ARCH  : ${UMBA_TARGET_ARCH}")
    endif()
endif()

if (NOT UMBA_TARGET_ARCH)
    umba_early_detection_check_for_target_msvc_cl_env(umbaTmp_isTargetMsvcMakefileOrNinja)
    if (umbaTmp_isTargetMsvcMakefileOrNinja)
        umba_early_detection_check_for_target_arch_msvc_cl_env(UMBA_TARGET_ARCH)
        set(UMBA_TARGET_SYSTEM "windows")
        set(UMBA_MSVC TRUE)
    endif()
    if (UMBA_TARGET_ARCH AND UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_HOST_TARGET)
        message(STATUS "UMBA: Autodetected MSVC command line mode")
        message(STATUS "UMBA: Autodetected UMBA_TARGET_SYSTEM: ${UMBA_TARGET_SYSTEM}")
        message(STATUS "UMBA: Autodetected UMBA_TARGET_ARCH  : ${UMBA_TARGET_ARCH}")
    endif()
endif()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
# Detect MinGW/GCC target

if (NOT UMBA_TARGET_ARCH)
    umba_early_detection_check_for_target_windows_mingw_gcc(umbaTmp_isTargetWindowsMinGW_GCC)
    if (umbaTmp_isTargetWindowsMinGW_GCC)
        umba_early_detection_check_for_target_arch_windows_mingw_gcc(UMBA_TARGET_ARCH)
        set(UMBA_TARGET_SYSTEM "mingw")
        set(UMBA_GCC TRUE)
    endif()
    if (UMBA_TARGET_ARCH AND UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_HOST_TARGET)
        message(STATUS "UMBA: Autodetected GCC MinGW/Windows")
        message(STATUS "UMBA: Autodetected UMBA_TARGET_SYSTEM: ${UMBA_TARGET_SYSTEM}")
        message(STATUS "UMBA: Autodetected UMBA_TARGET_ARCH  : ${UMBA_TARGET_ARCH}")
    endif()
endif()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
if (NOT UMBA_HOST_SYSTEM)

    if (CMAKE_HOST_WIN32)

        if (NOT UMBA_HOST_SYSTEM)
            umba_early_detection_check_for_target_windows_mingw_gcc(umbaTmp_isTargetWindowsMinGW_GCC)
            if (umbaTmp_isTargetWindowsMinGW_GCC)
                set(UMBA_HOST_SYSTEM "mingw")
            endif()
        endif()

        if (NOT UMBA_HOST_SYSTEM)
            umba_early_detection_check_for_target_msvc_sln(umbaTmp_isTargetMsvcSln)
            umba_early_detection_check_for_target_msvc_cl_env(umbaTmp_isTargetMsvcMakefileOrNinja)
            if (umbaTmp_isTargetMsvcSln OR umbaTmp_isTargetMsvcMakefileOrNinja)
                set(UMBA_HOST_SYSTEM "windows")
            endif()
        endif()

        if (UMBA_HOST_SYSTEM AND UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_HOST_TARGET)
            message(STATUS "UMBA: Autodetected UMBA_HOST_SYSTEM  : ${UMBA_HOST_SYSTEM}")
        endif()


    endif()

endif()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
if (NOT UMBA_HOST_ARCH) # (1)

    set(UMBA_HOST_ARCH "${CMAKE_HOST_SYSTEM_PROCESSOR}")

    if (NOT UMBA_HOST_ARCH) # (2)

        if (CMAKE_HOST_WIN32)

            # PROCESSOR_ARCHITEW6432
            # PROCESSOR_ARCHITECTURE

            # Получаем реальную хостовую архитектуру
            if (DEFINED ENV{PROCESSOR_ARCHITEW6432})
                set(umbaTmp_hostProcessorArch $ENV{PROCESSOR_ARCHITEW6432})
            elseif (DEFINED ENV{PROCESSOR_ARCHITECTURE})
                set(umbaTmp_hostProcessorArch $ENV{PROCESSOR_ARCHITECTURE})
            endif()

            umba_early_detection_extract_canonical_target_arch_name(UMBA_HOST_ARCH "${umbaTmp_hostProcessorArch}")

        # elseif(...) # !!! Тут надо проверить другие хостовые платформы

        endif() # CMAKE_HOST_WIN32

        if (UMBA_HOST_ARCH AND UMBA_CMAKE_VERBOSE AND UMBA_CMAKE_TRACE AND UMBA_CMAKE_TRACE_HOST_TARGET)
            message(STATUS "UMBA: Autodetected UMBA_HOST_ARCH    : ${UMBA_HOST_ARCH}")
        endif()

    endif() # NOT UMBA_HOST_ARCH # (2)

endif() # NOT UMBA_HOST_ARCH # (1)

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
if (NOT UMBA_HOST_ARCH)
    message(FATAL_ERROR "Failed to detect host architecture (UMBA_HOST_ARCH)")
endif()

if (NOT UMBA_HOST_SYSTEM)
    message(FATAL_ERROR "Failed to detect host architecture (UMBA_HOST_SYSTEM)")
endif()

#----------------------------------------------------------------------------




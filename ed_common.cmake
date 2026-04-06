# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Early detection (Раннее обнаружение) - общее
# ----------------------------------------------------------------

cmake_minimum_required(VERSION 3.25)

include_guard(GLOBAL)

#----------------------------------------------------------------------------
function(umba_early_detection_extract_canonical_target_arch_name OUTPUT_VAR INPUT_ARCH_STR)

    # ARM 64
    # ? arm64s armv7s armv7l
    if ("${INPUT_ARCH_STR}" MATCHES "ARM64")
        set(${OUTPUT_VAR} "arm64" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "aarch64")
        set(${OUTPUT_VAR} "arm64" PARENT_SCOPE)


    # ARM 32
    elseif ("${INPUT_ARCH_STR}" MATCHES "ARM32")
        set(${OUTPUT_VAR} "arm" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "aarch32")
        set(${OUTPUT_VAR} "arm" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "armv7")
        set(${OUTPUT_VAR} "arm" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "ARM")
        set(${OUTPUT_VAR} "arm" PARENT_SCOPE)

    # riscv32 riscv64
    # loongarch32 loongarch64
    # wasm32-emscripten

    # x64
    elseif ("${INPUT_ARCH_STR}" MATCHES "AMD64")
        set(${OUTPUT_VAR} "x64" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "x86_64")
        set(${OUTPUT_VAR} "x64" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "x86-64")
        set(${OUTPUT_VAR} "x64" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "X64")
        set(${OUTPUT_VAR} "x64" PARENT_SCOPE)

    # x86
    elseif ("${INPUT_ARCH_STR}" MATCHES "i686")
        set(${OUTPUT_VAR} "x86" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "i586")
        set(${OUTPUT_VAR} "x86" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "i486")
        set(${OUTPUT_VAR} "x86" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "i386")
        set(${OUTPUT_VAR} "x86" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "x86")
        set(${OUTPUT_VAR} "x86" PARENT_SCOPE)
    elseif ("${INPUT_ARCH_STR}" MATCHES "Win32")
        set(${OUTPUT_VAR} "x86" PARENT_SCOPE)

    # Ничего не найдено
    else()
        set(${OUTPUT_VAR} FALSE PARENT_SCOPE)
    endif()

endfunction()


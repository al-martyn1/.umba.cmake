# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Early detection (Раннее обнаружение) - MinGW
# ----------------------------------------------------------------

# Early detection - ED - MINGW detecting

cmake_minimum_required(VERSION 3.25)

include_guard(GLOBAL)

include("${CMAKE_CURRENT_LIST_DIR}/ed_common.cmake")

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
#[===[

Qt-шный GCC под виндой лежит обычно по таким путям:
  /mingw730_32/
  /mingw730_64/
  /mingw810_32/
  /mingw810_64/

Отдельный GCC может лежать по таким путям:
  /mingw-gcc-13.2/
  /mingw-gcc-15.2/

cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++

Сборка с MinGW/GCC из командной строки
  cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ ..
  cmake -G "MinGW Makefiles" ..
  cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++
  cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=i686-w64-mingw32-gcc -DCMAKE_CXX_COMPILER=i686-w64-mingw32-g++
  cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=aarch64-w64-mingw32-gcc -DCMAKE_CXX_COMPILER=aarch64-w64-mingw32-g++ ..
  cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ ..

Известные варианты имён GCC
x86_64-w64-mingw32-g++.exe
x86_64-w64-mingw32-gcc.exe
i686-w64-mingw32-g++.exe
i686-w64-mingw32-gcc.exe
arm-none-eabi-g++.exe
arm-none-eabi-gcc.exe

x86_64-w64-mingw32-gcc    # 64-bit
i686-w64-mingw32-gcc      # 32-bit

#]===]

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
# Проверяем, если задан CMAKE_C_COMPILER и там есть mingw или gcc, то это наше
function(umba_early_detection_check_for_target_windows_mingw_gcc OUTPUT_VAR)
    
    if (NOT CMAKE_HOST_WIN32) # под не виндой MINGW вроде тоже бывает, для кросс-сборки под винду, но мы пока это не рассматриваем

        set(${OUTPUT_VAR} FALSE PARENT_SCOPE)

    # Под MinGW (Windows) CMAKE_C_COMPILER путь к компилятору почему-то определён и до директивы project

    elseif(CMAKE_C_COMPILER MATCHES "mingw")
        set(${OUTPUT_VAR} TRUE PARENT_SCOPE)
    elseif(CMAKE_C_COMPILER MATCHES "gcc") # Вообще-то, GCC может встречаться и при кросс-сборке под микроконтроллеры, но пока это не рассматриваем
        set(${OUTPUT_VAR} TRUE PARENT_SCOPE)
    else()
        set(${OUTPUT_VAR} FALSE PARENT_SCOPE)
    endif()
        
endfunction()

#----------------------------------------------------------------------------
function(umba_early_detection_check_for_target_arch_windows_mingw_gcc OUTPUT_VAR)

    # Это повторная проверка на предмет того, правильно ли было вызвана функция
    umba_early_detection_check_for_target_windows_mingw_gcc(isWindowsMingwGcc)
    if (NOT isWindowsMingwGcc)
        message(FATAL_ERROR "umba_early_detection_check_for_target_arch_windows_mingw_gcc called not for MinGW/GCC compiler")
    endif()

    # Вызываем GCC с опцией -dumpmachine, которая выдаёт инфу, какой таргет у компилятора
    execute_process(
        COMMAND ${CMAKE_C_COMPILER} -dumpmachine
        OUTPUT_VARIABLE DUMPMACHINE_OUTPUT
        ERROR_VARIABLE DUMPMACHINE_ERROR
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    # message(STATUS "GCC Target (raw): ${DUMPMACHINE_OUTPUT}")
    umba_early_detection_extract_canonical_target_arch_name(umbaRes "${DUMPMACHINE_OUTPUT}")
    if (umbaRes)
        set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)
    endif()

endfunction()






# А можно ли как-то в CMake скрипте до директивы project проверить, какая целевая платформа, если задан компилятор gcc.exe?
# F:\_github\ttrade\ttrade\.cmake>gcc -dumpmachine
# x86_64-w64-mingw32
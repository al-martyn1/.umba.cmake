# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Early detection (Раннее обнаружение) - MSVC
# ----------------------------------------------------------------

# Early detection - ED - MSVC detecting

cmake_minimum_required(VERSION 3.25)

include_guard(GLOBAL)

include("${CMAKE_CURRENT_LIST_DIR}/ed_common.cmake")

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
#[===[

Сборка с MSVC - командная строка (надо предварительно запустить vcvarsall.bat):
  cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=17 ..

Сборка с MSVC - генерация sln(x) для MSVS или msbuild
  cmake -S ".." -G "Visual Studio 18 2026"  -A Win32 -B "..\.out\msvc2026\x86"


Детектим винду и MSVC до директивы project

Переменные CMake:
  CMAKE_HOST_WIN32 - определена всегда для винды, хоть "Visual Studio", хоть Ninja из ком строки с vcvarsall.bat, хоть Ninja из VSCode
  CMAKE_HOST_SYSTEM_NAME: Windows - определена
  CMAKE_GENERATOR  - определена, "Visual Studio..."/"Ninja"/etc
  CMAKE_GENERATOR_PLATFORM - определена для "Visual Studio", для Ninja - не определена
  CMAKE_C_COMPILER: D:/Qt/Tools/mingw810_64/bin/gcc.exe - определена для Ninja/VSCode, для Visual Studio не определена

Если собирать не MSVS/msbuild, а, например, Ninja:
  > cd cmake
  > md build
  > cd build
  > call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x64
  > cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=17 ..\..
  > cmake --build .

то vcvarsall.bat задаёт следующие переменные среды (переменную Path дополняет в начале):
  CommandPromptType=Native
  Framework40Version=v4.0
  FrameworkDir=C:\Windows\Microsoft.NET\Framework64
  FrameworkDIR64=C:\Windows\Microsoft.NET\Framework64
  FrameworkVersion=v4.0.30319
  FrameworkVersion64=v4.0.30319
  INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\INCLUDE;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\ucrt;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6.1\include\um;C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\shared;C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\um;C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\winrt;
  LIB=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\LIB\amd64;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\ATLMFC\LIB\amd64;C:\Program Files (x86)\Windows Kits\10\lib\10.0.26100.0\ucrt\x64;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6.1\lib\um\x64;C:\Program Files (x86)\Windows Kits\10\lib\10.0.26100.0\um\x64;
  LIBPATH=C:\Windows\Microsoft.NET\Framework64\v4.0.30319;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\LIB\amd64;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\ATLMFC\LIB\amd64;C:\Program Files (x86)\Windows Kits\10\UnionMetadata;C:\Program Files (x86)\Windows Kits\10\References;C:\Program Files (x86)\Microsoft SDKs\Windows Kits\10\ExtensionSDKs\Microsoft.VCLibs\14.0\References\CommonConfiguration\neutral;
  NETFXSDKDir=C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6.1\
  Path=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\BIN\amd64;C:\Windows\Microsoft.NET\Framework64\v4.0.30319;C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE;C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools;C:\Program Files (x86)\HTML Help Workshop;C:\Program Files (x86)\Windows Kits\10\bin\x64;C:\Program Files (x86)\Windows Kits\10\bin\x86;C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\x64\
  Platform=X64
  UCRTVersion=10.0.26100.0
  UniversalCRTSdkDir=C:\Program Files (x86)\Windows Kits\10\
  VCINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\
  WindowsLibPath=C:\Program Files (x86)\Windows Kits\10\UnionMetadata;C:\Program Files (x86)\Windows Kits\10\References
  WindowsSdkDir=C:\Program Files (x86)\Windows Kits\10\
  WindowsSDKLibVersion=10.0.26100.0\
  WindowsSDKVersion=10.0.26100.0\
  WindowsSDK_ExecutablePath_x64=C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\x64\
  WindowsSDK_ExecutablePath_x86=C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\

  Platform=x86/x64/arm/arm64
  x64 ^| x86 ^| arm64 ^| x64_x86 ^| x64_arm64 ^| x86_x64 ^| x86_arm64 ^| arm64_x64 ^| arm64_x86
         x86  | amd64  | arm      | x86_amd64  | x86_arm  | amd64_x86  | amd64_arm
  x86 amd64 arm x86_amd64 x86_arm amd64_x86 amd64_arm


  vswhere - https://learn.microsoft.com/ru-ru/visualstudio/install/tools-for-managing-visual-studio-instances?view=visualstudio

#]===]

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
# Проверяем, используется ли генератор под вижуалку/msbuild
function(umba_early_detection_check_for_target_msvc_sln OUTPUT_VAR)
    
    if (NOT CMAKE_HOST_WIN32)
        set(${OUTPUT_VAR} FALSE PARENT_SCOPE)
    elseif(CMAKE_GENERATOR MATCHES "Visual Studio")
        set(${OUTPUT_VAR} TRUE PARENT_SCOPE)
    endif()

endfunction()

#----------------------------------------------------------------------------
# Генератор под вижуалку/msbuild содержит архитектуру в переменной CMAKE_GENERATOR_PLATFORM
function(umba_early_detection_check_for_target_arch_msvc_sln OUTPUT_VAR)

    # Это повторная проверка на предмет того, правильно ли было вызвана функция
    # Проверяем, используется ли генератор под вижуалку/msbuild
    umba_early_detection_check_for_target_msvc_sln(isMsvcSln) 
    if (NOT isMsvcSln)
        message(FATAL_ERROR "umba_early_detection_check_for_target_arch_msvc_sln called not for MSVC Solution generator")
    endif()

    # Для "Visual Studio ..." генератора переменная CMAKE_GENERATOR_PLATFORM должна быть определена
    if (CMAKE_GENERATOR_PLATFORM)
        umba_early_detection_extract_canonical_target_arch_name(umbaRes "${CMAKE_GENERATOR_PLATFORM}")
        set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "umba_early_detection_check_for_target_arch_msvc_sln called for MSVC Solution generator, but CMAKE_GENERATOR_PLATFORM variable not defined")
    endif()
    
endfunction()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
# Если собираем через make/ninja, но был запущен vcvarsall.bat и компилятор - CL
function(umba_early_detection_check_for_target_msvc_cl_env OUTPUT_VAR)
    
    if (NOT CMAKE_HOST_WIN32) # Пока считаем, что вижуалка у нас только под x86/x64 виндой

        set(${OUTPUT_VAR} FALSE PARENT_SCOPE)

    else() # CMAKE_HOST_WIN32
        
        if (DEFINED ENV{LIBPATH})

            set(envLibPath $ENV{LIBPATH})

            # Можно ещё так: CMAKE_C_COMPILER: C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/bin/cl.exe
            # В случае vcvarsall.bat переменная CMAKE_C_COMPILER определена, и можно детектить cl.exe
            if ("${envLibPath}" MATCHES "Visual Studio" OR envLibPath MATCHES "Windows Kits" OR envLibPath MATCHES "Microsoft SDK")
                set(${OUTPUT_VAR} TRUE PARENT_SCOPE)
            else()
                set(${OUTPUT_VAR} FALSE PARENT_SCOPE)
            endif()
        else()
            set(${OUTPUT_VAR} FALSE PARENT_SCOPE)
        endif()

    endif() # CMAKE_HOST_WIN32

endfunction()

#----------------------------------------------------------------------------
function(umba_early_detection_check_for_target_arch_msvc_cl_env OUTPUT_VAR)
    
    # Это повторная проверка на предмет того, правильно ли было вызвана функция
    # Проверяем, используется ли генератор Make/Ninja совместно с компиляторов вижуалки
    umba_early_detection_check_for_target_msvc_cl_env(isMsvcClEnv)
    if (NOT isMsvcClEnv)
        message(FATAL_ERROR "umba_early_detection_check_for_target_arch_msvc_cl_env called not for Make/Ninja generator for MSVC CL compiler")
    endif()

    if (NOT DEFINED ENV{Platform})
        message(FATAL_ERROR "umba_early_detection_check_for_target_arch_msvc_cl_env called for Make/Ninja generator for MSVC CL compiler, but 'Platform' environment variable not defined")
    else()
        set(tmpPlatform $ENV{Platform})
        if (NOT tmpPlatform)
            message(FATAL_ERROR "umba_early_detection_check_for_target_arch_msvc_cl_env called for Make/Ninja generator for MSVC CL compiler, but failed to get 'Platform' environment variable value")
        else()
            umba_early_detection_extract_canonical_target_arch_name(umbaRes "${tmpPlatform}")
            if (NOT umbaRes)
                message(FATAL_ERROR "umba_early_detection_check_for_target_arch_msvc_cl_env: failed to extract ARCH from 'Platform' string ('${tmpPlatform}')")
            else()
                set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)
            endif()
        endif()
    endif()

endfunction()
#----------------------------------------------------------------------------


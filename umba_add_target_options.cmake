# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Работа со строками
# ----------------------------------------------------------------

include_guard(GLOBAL)


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
                target_compile_options(${TARGET} PRIVATE "-fpermissive")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                #message(NOTICE "Add PERMISSIVE options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                # https://devblogs.microsoft.com/cppblog/broken-warnings-theory/
                # https://habr.com/ru/companies/pvs-studio/articles/347686/
                # https://learn.microsoft.com/en-us/cpp/build/reference/compiler-option-warning-level?view=msvc-170
                target_compile_options(${TARGET} PRIVATE "/W2" "/permissive" "/external:anglebrackets" "/external:W0")

            endif()

        
        elseif(${CURARG} STREQUAL "NOWARNPACKALIGN" OR ${CURARG} STREQUAL "NO_WARN_PACKALIGN" OR ${CURARG} STREQUAL "NO_WARN_PACK_ALIGN")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                #message(NOTICE "Add NOWARNPACKALIGN options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                #message(NOTICE "Add NOWARNPACKALIGN options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                #message(NOTICE "Add NOWARNPACKALIGN options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                target_compile_options(${TARGET} PRIVATE "/wd4315")

            endif()

        
        elseif(${CURARG} STREQUAL "WNOERR" OR ${CURARG} STREQUAL "WNOERROR" OR ${CURARG} STREQUAL "WERR-"  OR ${CURARG} STREQUAL "WERROR-")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                #message(NOTICE "Add WERR- options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                # https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
                target_compile_options(${TARGET} PRIVATE "-Wno-error")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                #message(NOTICE "Add WALL options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                # https://devblogs.microsoft.com/cppblog/broken-warnings-theory/
                # https://habr.com/ru/companies/pvs-studio/articles/347686/
                # https://learn.microsoft.com/en-us/cpp/build/reference/compiler-option-warning-level?view=msvc-170
                target_compile_options(${TARGET} PRIVATE "/WX-")

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

        
        elseif(${CURARG} STREQUAL "GRPCNOWARN" OR ${CURARG} STREQUAL "GRPC_NO_WARN" OR ${CURARG} STREQUAL "PROTOBUFCNOWARN" OR ${CURARG} STREQUAL "PROTOBUF_NO_WARN")

            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

                #message(NOTICE "Add NOWARNPACKALIGN options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

                #message(NOTICE "Add NOWARNPACKALIGN options for Clang")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

                #message(NOTICE "Add NOWARNPACKALIGN options for Intel")

            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

                target_compile_options(${TARGET} PRIVATE "/wd4668") # warning C4668: 'IDENT' is not defined as a preprocessor macro, replacing with '0' for '#if/#elif'
                target_compile_options(${TARGET} PRIVATE "/wd4365") # warning C4365: 'initializing': conversion from 'unsigned __int64' to 'ptrdiff_t', signed/unsigned mismatch
                target_compile_options(${TARGET} PRIVATE "/wd4100") # warning C4100: 'Ident': unreferenced parameter
                target_compile_options(${TARGET} PRIVATE "/wd4625") # warning C4625: 'Ident': copy constructor was implicitly defined as deleted
                target_compile_options(${TARGET} PRIVATE "/wd5026") # warning C5026: 'Ident': move constructor was implicitly defined as deleted
                target_compile_options(${TARGET} PRIVATE "/wd5243") # warning C5243: 'void (__cdecl Ident::* )(void)': using incomplete class 'Ident' can cause potential one definition rule violation due to ABI limitation
                target_compile_options(${TARGET} PRIVATE "/wd4267") # warning C4267: 'argument': conversion from 'size_t' to 'const _Ty', possible loss of data
                target_compile_options(${TARGET} PRIVATE "/wd4623") # warning C4623: 'Ident': default constructor was implicitly defined as deleted
                target_compile_options(${TARGET} PRIVATE "/wd4800") # warning C4800: Implicit conversion from 'Ident *' to bool. Possible information loss
                target_compile_options(${TARGET} PRIVATE "/wd4946") # warning C4946: reinterpret_cast used between related classes: 'Ident1' and 'Ident2'
                target_compile_options(${TARGET} PRIVATE "/wd4189") # warning C4189: 'Ident': local variable is initialized but not referenced

            endif()

        endif() # if(${CURARG}

    endforeach()

endfunction()

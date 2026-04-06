# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Работа со строками
# ----------------------------------------------------------------

include_guard(GLOBAL)

include("${CMAKE_CURRENT_LIST_DIR}/functions_base.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/mathlib.cmake")

#----------------------------------------------------------------------------


#----------------------------------------------------------------------------

# function(umba_str_len OUTPUT_VAR STR)
# function(umba_str_get_first_char OUTPUT_VAR STR)
# function(umba_str_get_last_char OUTPUT_VAR STR)
# function(umba_str_strip_first_char OUTPUT_VAR STR)
# function(umba_str_strip_last_char OUTPUT_VAR STR)

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------

# https://cmake.org/cmake/help/latest/command/string.html
# 
# Search and Replace
#   string(FIND <string> <substring> <out-var> [...])
#   string(REPLACE <match-string> <replace-string> <out-var> <input>...)
#   string(REGEX MATCH <match-regex> <out-var> <input>...)
#   string(REGEX MATCHALL <match-regex> <out-var> <input>...)
#   string(REGEX REPLACE <match-regex> <replace-expr> <out-var> <input>...)
# 
# Manipulation
#   string(APPEND <string-var> [<input>...])
#   string(PREPEND <string-var> [<input>...])
#   string(CONCAT <out-var> [<input>...])
#   string(JOIN <glue> <out-var> [<input>...])
#   string(TOLOWER <string> <out-var>)
#   string(TOUPPER <string> <out-var>)
#   string(LENGTH <string> <out-var>)
#   string(SUBSTRING <string> <begin> <length> <out-var>)
#   string(STRIP <string> <out-var>)
#   string(GENEX_STRIP <string> <out-var>)
#   string(REPEAT <string> <count> <out-var>)
#   string(REGEX QUOTE <out-var> <input>...)
# 
# Comparison
#   string(COMPARE <op> <string1> <string2> <out-var>)
# 
# Hashing
#   string(<HASH> <out-var> <input>)
# 
# Generation
#   string(ASCII <number>... <out-var>)
#   string(HEX <string> <out-var>)
#   string(CONFIGURE <string> <out-var> [...])
#   string(MAKE_C_IDENTIFIER <string> <out-var>)
#   string(RANDOM [<option>...] <out-var>)
#   string(TIMESTAMP <out-var> [<format string>] [UTC])
#   string(UUID <out-var> ...)

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
function(umba_str_len OUTPUT_VAR STR)

    string(LENGTH "${STR}" umbaRes)
    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)

endfunction()

#----------------------------------------------------------------------------
function(umba_str_tolower OUTPUT_VAR STR)
    string(TOLOWER "${STR}" umbaRes)
    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)
endfunction()

#----------------------------------------------------------------------------
function(umba_str_toupper OUTPUT_VAR STR)
    string(TOUPPER "${STR}" umbaRes)
    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)
endfunction()

#----------------------------------------------------------------------------
function(umba_str_substr_be OUTPUT_VAR STR BEGIN END)

    umba_str_len(strLen ${STR})

    if (${BEGIN} GREATER_EQUAL ${strLen})

        set(${OUTPUT_VAR} "" PARENT_SCOPE)

    else()
        
        if(${END} GREATER ${strLen})
            set(END_ ${strLen})
        else()
            set(END_ ${END})
        endif()

        umba_math_eval(SLEN "${END_} - ${BEGIN}")

        if (${SLEN} LESS 1)
            set(${OUTPUT_VAR} "" PARENT_SCOPE)
        else()
            string(SUBSTRING ${STR} ${BEGIN} ${SLEN} umbaRes)
            set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)
        endif()

    endif()

endfunction()

#----------------------------------------------------------------------------
function(umba_str_substr_len OUTPUT_VAR STR POS LEN)

    umba_math_eval(END "${POS} + ${LEN}")
    umba_str_substr_be(umbaRes ${STR} ${POS} ${END} res)
    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)

endfunction()

#----------------------------------------------------------------------------
function(umba_str_get_first_char OUTPUT_VAR STR)

    if(NOT STR)
        set(${OUTPUT_VAR} "" PARENT_SCOPE)
    else()
        string(SUBSTRING ${STR} 0 1 umbaRes)
        set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)
    endif()

endfunction()

#----------------------------------------------------------------------------
function(umba_str_get_last_char OUTPUT_VAR STR)

    umba_str_len(strLen ${STR})
    umba_math_eval(startPos "${strLen} - 1")

    umba_str_substr_be(umbaRes ${STR} ${startPos} ${strLen})
    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)

endfunction()

#----------------------------------------------------------------------------
function(umba_str_strip_first_char OUTPUT_VAR STR)

    umba_str_len(strLen ${STR})
    umba_str_substr_be(umbaRes ${STR} 1 ${strLen})
    set(res ${umbaResult})
    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)

endfunction()

#----------------------------------------------------------------------------
function(umba_str_strip_last_char OUTPUT_VAR STR)

    umba_str_len(strLen ${STR})
    umba_math_eval(lenMinus1 "${strLen} - 1")
    umba_str_substr_be(umbaRes ${STR} 0 ${lenMinus1})
    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)

endfunction()

#----------------------------------------------------------------------------
function(umba_str_first_char_equ OUTPUT_VAR STR CH)

    umba_str_get_first_char(FIRST_CH ${STR})
    if(${FIRST_CH} STREQUAL ${CH})
        set(${OUTPUT_VAR} TRUE PARENT_SCOPE)
    else()
        set(${OUTPUT_VAR} FALSE PARENT_SCOPE)
    endif()

endfunction()

#----------------------------------------------------------------------------
function(umba_str_last_char_equ OUTPUT_VAR STR CH)

    umba_str_get_last_char(LAST_CH ${STR})
    if(${LAST_CH} STREQUAL ${CH})
        set(${OUTPUT_VAR} TRUE PARENT_SCOPE)
    else()
        set(${OUTPUT_VAR} FALSE PARENT_SCOPE)
    endif()

endfunction()

#----------------------------------------------------------------------------
function(umba_str_split_to_chars OUTPUT_VAR STR)

    set(umbaRes "")
    # umba_str_len(${STR})

    while(NOT "${STR}" STREQUAL "")

        umba_str_get_first_char(FIRST_CH ${STR})
        list(APPEND umbaRes ${FIRST_CH})

        # message(STATUS "FC1: ${umbaResult}")

        umba_str_strip_first_char(STR ${STR})

        # message(STATUS "FC2: ${umbaResult}")

    endwhile()

    set(${OUTPUT_VAR} ${umbaResult} PARENT_SCOPE)

endfunction()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
function(test_umba_str_get_strip_first_last_char STR)

    message(STATUS "=== test_umba_str_get_strip_first_last_char ===")
    message(STATUS "Input  : ${STR}")
    message(STATUS "As chars:")

    umba_str_split_to_chars(umbaRes ${STR})
    foreach(CH ${umbaRes})
        message(STATUS "  ${CH}")
    endforeach()

    umba_str_len(umbaRes ${STR})
    message(STATUS "Len    : ${umbaRes}")

    umba_str_get_first_char(umbaRes ${STR})
    message(STATUS "FirstCh: ${umbaRes}")

    umba_str_get_last_char(umbaRes ${STR})
    message(STATUS "LastCh : ${umbaRes}")

    umba_str_strip_first_char(umbaRes ${STR})
    message(STATUS "First char stripped: ${umbaRes}")

    umba_str_strip_last_char(umbaRes ${STR})
    message(STATUS "Last char stripped : ${umbaRes}")

    umba_str_first_char_equ(umbaRes ${STR} "0")
    message(STATUS "First char == 0 : ${umbaRes}")

    umba_str_first_char_equ(umbaRes ${STR} "1")
    message(STATUS "First char == 1 : ${umbaRes}")

    umba_str_last_char_equ(umbaRes ${STR} "9")
    message(STATUS "First char == 9 : ${umbaRes}")

    umba_str_last_char_equ(umbaRes ${STR} "1")
    message(STATUS "Last char == 1  : ${umbaRes}")

endfunction()

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------




# if("${STR}" STREQUAL "")
















# function(umba_math_eval EVAL_EXPRESSION)




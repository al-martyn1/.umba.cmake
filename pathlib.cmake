# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Работа с путями
# ----------------------------------------------------------------

include_guard(GLOBAL)

include("${CMAKE_CURRENT_LIST_DIR}/functions_base.cmake")

#[===[

  function(umba_path_normalize OUTPUT_VAR PATH)
  function(umba_path_split_pathlist OUTPUT_VAR PATHLIST)
  function(umba_path_split_pathlist_env_var OUTPUT_VAR ENV_VAR_NAME)

#]===]


#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
function(umba_path_normalize OUTPUT_VAR PATH)

    cmake_path(SET normalizedRes NORMALIZE ${PATH})
    string(REPLACE "//" "/" umbaRes "${normalizedRes}")
    # umba_return("${umbaRes}")
    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)

endfunction()

#----------------------------------------------------------------------------
function(umba_path_split_pathlist OUTPUT_VAR PATHLIST)

    if (PATHLIST)
        if (CMAKE_HOST_WIN32)
            string(REPLACE ";" ";" umbaRes "${PATHLIST}")
        else()
            string(REPLACE ":" ";" umbaRes "${PATHLIST}")
        endif()
    else()
        set(umbaRes "")
    endif()

    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE) # Ничего особенно делать и не надо, строка с точкозапятыми это и есть список в CMake

endfunction()

#----------------------------------------------------------------------------
function(umba_path_split_pathlist_env_var OUTPUT_VAR ENV_VAR_NAME)

    if (DEFINED ENV{${ENV_VAR_NAME}})

        set(ENVVARVAL_PATHLIST $ENV{${ENV_VAR_NAME}})
        # message(STATUS "ENVVARVAL_PATHLIST: ${ENVVARVAL_PATHLIST}") # гут, до сюда работает
    
        if (NOT ENVVARVAL_PATHLIST)
            set(${OUTPUT_VAR} "" PARENT_SCOPE)
        else()
            umba_path_split_pathlist(umbaRes "${ENVVARVAL_PATHLIST}")
            set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)
        endif()

    else()

        set(${OUTPUT_VAR} "" PARENT_SCOPE)

    endif()

endfunction()

#----------------------------------------------------------------------------
#function()
#endfunction()


# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Математические функции
# ----------------------------------------------------------------

include_guard(GLOBAL)

include("${CMAKE_CURRENT_LIST_DIR}/functions_base.cmake")

#----------------------------------------------------------------------------



#----------------------------------------------------------------------------
function(umba_math_eval OUTPUT_VAR EVAL_EXPRESSION)
    math(EXPR umbaRes "${EVAL_EXPRESSION}")
    set(${OUTPUT_VAR} "${umbaRes}" PARENT_SCOPE)
endfunction()

#----------------------------------------------------------------------------

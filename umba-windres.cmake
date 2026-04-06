# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief Попытка подменить windres в MinGW
# ----------------------------------------------------------------

include_guard(GLOBAL)

function(umba_fix_windres)

# Фиксим проблему с MINGW windres - он передаёт инклюды в препроцессор не экранируя, из-за этого
# пути, которые содержат пробелы, разбиваются на отдельные аргументы, и препроцессор выдаёт ошибки
# https://cmake.org/cmake/help/latest/command/find_program.html

find_program(UMBA_WINDRES_EXECUTABLE "umba-windres")

message("umba_fix_windres (1): CMAKE_RC_COMPILE_OBJECT: ${CMAKE_RC_COMPILE_OBJECT}")
# Если тулчейн MINGW'шный и утилита umba-windres найдена, то фиксим, иначе пусть работает, как работало
if(MINGW AND UMBA_WINDRES_EXECUTABLE)
    #set(UMBA_WINDRES "${UMBA_WINDRES_EXECUTABLE}" CACHE STRING "umba-windres proxy" FORCE)
    set(ENV{UMBA_WINDRES} "${UMBA_WINDRES_EXECUTABLE}")
    # enable_language(RC)
    # https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables
    message("umba_fix_windres: MINGW AND UMBA_WINDRES fires")
    message("umba_fix_windres: UMBA_WINDRES: ${UMBA_WINDRES}")
    # https://man7.org/linux/man-pages/man1/windres.1.html
    set(CMAKE_RC_COMPILE_OBJECT 
        # "<CMAKE_RC_COMPILER> --use-temp-file -O coff <DEFINES> <INCLUDES> <FLAGS> -i <SOURCE> -o <OBJECT>"

        # Вызов прокси umba-windres. Первым аргументом (опционально) передаётя полный путь к оригинальному windres
        # Если не передан путь к windres, то вызывается windres(.exe) без пути
        # Прокси umba-windres проверяет каждый аргумент. Если родительский каталог элемента является существующим путём
        # (сам элемент может не существовать, так как выходной файл, например), то производится его конвертация
        # в короткое имя 8.3 (но в системе это может быть отключено, по умолчанию - включено)
        # UNC/сетевые пути не поддерживаются, но кто в здравом уме их использует при сборке проекта?
        "\$ENV{UMBA_WINDRES} --use-temp-file <FLAGS> -O coff <DEFINES> <INCLUDES> <SOURCE> <OBJECT>"

        CACHE STRING "Команда компиляции RC с исправлением пробелов" 
        FORCE  # это главное!

        # PARENT_SCOPE
        )
    #set(CMAKE_RC_COMPILE_OBJECT 
    #    "<UMBA_WINDRES> <CMAKE_RC_COMPILER> --use-temp-file <FLAGS> -O coff <DEFINES> <INCLUDES> <SOURCE> <OBJECT>"
    #    )
    #set(CMAKE_RC_COMPILE_OBJECT 
    #    "<UMBA_WINDRES> <CMAKE_RC_COMPILER> --use-temp-file <FLAGS> -O coff <DEFINES> <INCLUDES> <SOURCE> <OBJECT>"
    #    PARENT_SCOPE
    #    )

endif()
message("umba_fix_windres (2): CMAKE_RC_COMPILE_OBJECT: ${CMAKE_RC_COMPILE_OBJECT}")

endfunction()

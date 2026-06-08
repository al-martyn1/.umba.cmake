# author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
# copyright (c) 2024-2026 Alexander Martynov
# brief 
# ----------------------------------------------------------------

include_guard(GLOBAL)

if(DEFINED ENV{Z_VCPKG_POWERSHELL_PATH})
    set(Z_VCPKG_POWERSHELL_PATH "$ENV{Z_VCPKG_POWERSHELL_PATH}" CACHE INTERNAL "The path to the PowerShell implementation to use.")
endif()


@rem author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
@rem copyright (c) 2024-2026 Alexander Martynov
@rem brief 
@rem ----------------------------------------------------------------

@echo off
@rem powershell "((Get-Content -path \"%1\" -Raw) -replace 'namespace public {','namespace public_ {') | Set-Content -Path \"%1\""
@rem powershell "((Get-Content -path \"%1\" -Raw) -replace '::public::','::public_::')                 | Set-Content -Path \"%1\""

@if "%UMBA_SUBST_MACROS_EXECUTABLE%"=="" goto USE_POWERSHELL
@goto USE_UMBA_SUBST_MACROS
:USE_POWERSHELL
@powershell -File "%~dp0\fix_cpp_keywords.ps1" "%~1"
@goto END
:USE_UMBA_SUBST_MACROS
@set SUBST_OPTIONS="-S:namespace public {=namespace public_ {"
@set SUBST_OPTIONS=%SUBST_OPTIONS% "-S:::public::=::public_::"
@set SUBST_OPTIONS=%SUBST_OPTIONS% "-S:// namespace public=// namespace public_"
@"%UMBA_SUBST_MACROS_EXECUTABLE%" --overwrite --raw=1 --verbose=quet %SUBST_OPTIONS% "%~1" "%~1"
:END
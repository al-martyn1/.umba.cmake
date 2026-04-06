@rem author Alexander Martynov (Marty AKA al-martyn1) <amart@mail.ru>
@rem copyright (c) 2024-2026 Alexander Martynov
@rem brief 
@rem ----------------------------------------------------------------

dir "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
dir "C:\Program Files\Microsoft Visual Studio\Installer\vswhere.exe"

@rem reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\SxS\VS7" /v "15.0"
@rem reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\SxS\VS7" /v "16.0"
@rem reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\SxS\VS7" /v "17.0"

@echo off
setlocal enabledelayedexpansion

for /f "tokens=*" %%i in ('vswhere -latest -property installationPath 2^>nul') do (
    if exist "%%i\VC\Auxiliary\Build\vcvarsall.bat" (
        echo Found VS at: %%i
        for /d %%v in ("%%i\VC\Tools\MSVC\*") do (
            if exist "%%v\bin\Hostx64\x64\cl.exe" (
                echo Compiler: %%v\bin\Hostx64\x64\cl.exe
            )
        )
    )
)

@set VSWHERE=C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe

"%VSWHERE%" -version "[18.0,19.0)" -property installationPath
"%VSWHERE%" -version "[17.0,18.0)" -property installationPath
"%VSWHERE%" -version "[16.0,17.0)" -property installationPath
"%VSWHERE%" -version "[15.0,16.0)" -property installationPath

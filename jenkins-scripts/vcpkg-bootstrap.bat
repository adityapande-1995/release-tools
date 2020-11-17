@echo on
 
set SCRIPT_DIR=%~dp0
set PLATFORM_TO_BUILD=amd64

set win_lib=%SCRIPT_DIR%\lib\windows_library.bat

:: Call vcvarsall and all the friends
echo # BEGIN SECTION: configure the MSVC compiler
call %win_lib% :configure_msvc2019_compiler
echo # END SECTION

echo # BEGIN SECTION: Bootstrap vcpkg
@echo on
:: Remove previous vcpkg installation
rd /s /q %VCPKG_DIR%

:: Clone and use the new version of vcpkg
git clone https://github.com/microsoft/vcpkg %VCPKG_DIR% || goto :error
echo "Using SNAPSHOT: %VCPKG_SNAPSHOT%"
cd %VCPKG_DIR%
git checkout %VCPKG_SNAPSHOT% || goto :error
:: Bootstrap vcpkg.exe
%VCPKG_DIR%\bootstrap-vcpkg.bat -disableMetrics
echo # END SECTION
goto :EOF

:: ##################################
:error - error routine
::
echo Failed in with error #%errorlevel%.
exit /B %errorlevel%
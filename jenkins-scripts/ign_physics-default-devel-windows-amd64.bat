set SCRIPT_DIR="%~dp0"

set VCS_DIRECTORY=ign-physics
set PLATFORM_TO_BUILD=x86_amd64
set IGN_CLEAN_WORKSPACE=true

:: This needs to be migrated to DSL to get multi-major versions correctly
set COLCON_PACKAGE=ign-physics0
set GAZEBODISTRO_FILE=%COLCON_PACKAGE%.yaml

call "%SCRIPT_DIR%/lib/colcon-default-devel-windows.bat"

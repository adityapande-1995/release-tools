set SCRIPT_DIR="%~dp0"

set VCS_DIRECTORY=ign-physics
set PLATFORM_TO_BUILD=x86_amd64
set IGN_CLEAN_WORKSPACE=true

:: This needs to be migrated to DSL to get multi-major versions correctly
set GAZEBODISTRO_FILE="ign-physics0.yaml"

call "%SCRIPT_DIR%/lib/concon-default-devel-windows.bat"

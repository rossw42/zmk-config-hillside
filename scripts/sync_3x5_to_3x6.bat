@echo off
REM Sync 3x5 Core to 3x6
REM 
REM This script automatically syncs core keys from generic_3x5.keymap to generic_3x6.keymap
REM 
REM Mapping:
REM - Core 3x5 alpha keys stay the same
REM - 3x5 thumbs (2 per side) -> 3x6 middle thumbs (outer 2 of 3)
REM - Outer columns: Tab/Ctrl/Shift (left), Bspc/'/Shift (right)
REM - Extra thumb: Tab (left), GUI (right)
REM
REM Usage: scripts\sync_3x5_to_3x6.bat

setlocal enabledelayedexpansion

set KEYMAP_3X5=config\generic_3x5.keymap
set KEYMAP_3X6=config\generic_3x6.keymap

echo [33m🔄 Syncing 3x5 core keys to 3x6...[0m
echo.

REM Check if files exist
if not exist "%KEYMAP_3X5%" (
    echo [31m❌ Error: %KEYMAP_3X5% not found[0m
    exit /b 1
)

echo [36m📝 Extracting layers from %KEYMAP_3X5%...[0m
echo.

REM Use PowerShell to do the heavy lifting
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync_3x5_to_3x6.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo [31m❌ Error: Failed to sync keymaps[0m
    exit /b 1
)

echo.
echo [32m✅ Successfully synced 3x5 → 3x6![0m
echo.
echo [36m📋 Next steps:[0m
echo    1. Review %KEYMAP_3X6% to verify outer columns
echo    2. Run: scripts\sync_all_generic_layers.bat
echo    3. Commit and build!

endlocal

@echo off
REM Setup Git Hooks for ZMK Config
REM 
REM This script installs the pre-commit hook that automatically
REM syncs generic keymaps before each commit

setlocal enabledelayedexpansion

echo [33m🔧 Setting up Git hooks...[0m
echo.

REM Get the repo root
for /f "delims=" %%i in ('git rev-parse --show-toplevel') do set REPO_ROOT=%%i
set HOOKS_DIR=%REPO_ROOT%\.git\hooks
set PRE_COMMIT_HOOK=%HOOKS_DIR%\pre-commit
set SOURCE_HOOK=%REPO_ROOT%\scripts\pre-commit

REM Check if source hook exists
if not exist "%SOURCE_HOOK%" (
    echo [31m❌ Error: scripts\pre-commit not found[0m
    exit /b 1
)

REM Backup existing pre-commit hook if it exists
if exist "%PRE_COMMIT_HOOK%" (
    echo [36m📦 Backing up existing pre-commit hook...[0m
    move "%PRE_COMMIT_HOOK%" "%PRE_COMMIT_HOOK%.backup" >nul
    echo    Saved to: %PRE_COMMIT_HOOK%.backup
    echo.
)

REM Copy hook (Windows doesn't support symlinks easily)
echo [36m🔗 Installing pre-commit hook...[0m
copy "%SOURCE_HOOK%" "%PRE_COMMIT_HOOK%" >nul

echo.
echo [32m✓ Git hooks installed successfully![0m
echo.
echo [36m📋 What this does:[0m
echo    • Before each commit, automatically syncs:
echo      - generic_3x5.keymap → generic_3x6.keymap
echo      - Both keymaps → .dtsi files
echo    • Adds synced files to your commit
echo    • Ensures all boards stay in sync
echo.
echo [36m💡 To disable temporarily:[0m
echo    git commit --no-verify
echo.
echo [36m🗑️  To uninstall:[0m
echo    del %PRE_COMMIT_HOOK%
echo.

endlocal

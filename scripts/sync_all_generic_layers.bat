@echo off
REM Sync All Generic Layers
REM 
REM This script:
REM 1. Syncs generic_3x5.keymap → generic_3x5_layers.dtsi
REM 2. Syncs generic_3x6.keymap → generic_3x6_layers.dtsi
REM
REM Usage: scripts\sync_all_generic_layers.bat

setlocal enabledelayedexpansion

set KEYMAP_3X5=config\generic_3x5.keymap
set KEYMAP_3X6=config\generic_3x6.keymap
set DTSI_3X5=config\generic_3x5_layers.dtsi
set DTSI_3X6=config\generic_3x6_layers.dtsi

echo [33m🔄 Syncing all generic layers...[0m
echo.

REM Check if files exist
if not exist "%KEYMAP_3X5%" (
    echo [31m❌ Error: %KEYMAP_3X5% not found[0m
    exit /b 1
)
if not exist "%KEYMAP_3X6%" (
    echo [31m❌ Error: %KEYMAP_3X6% not found[0m
    exit /b 1
)

echo [36m📝 Step 1: Syncing 3x5 layers from %KEYMAP_3X5%...[0m

REM Use PowerShell for text processing
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"function Extract-Layer($content, $layerName) { ^
    if ($content -match \"(?s)$layerName \{.*?bindings = <(.*?)>;\" ) { ^
        $bindings = $matches[1].Trim() -split \"`n\" ^| ForEach-Object { $_.Trim() } ^| Where-Object { $_ -ne '' }; ^
        return ($bindings -join \" \\`n\"); ^
    } ^
    return ''; ^
} ^
$keymap3x5 = Get-Content '%KEYMAP_3X5%' -Raw; ^
$base = Extract-Layer $keymap3x5 'base_layer'; ^
$num = Extract-Layer $keymap3x5 'num_layer'; ^
$sym = Extract-Layer $keymap3x5 'sym_layer'; ^
$adj = Extract-Layer $keymap3x5 'adj_layer'; ^
$output = @'^
/*
 * Generic 3x5 Layer Definitions
 * 
 * This file is auto-generated from generic_3x5.keymap
 * Edit generic_3x5.keymap with keymap-editor, then run: scripts\sync_all_generic_layers.bat
 * 
 * Include this file in your board's keymap to use the shared layout
 */

// Base Layer - QWERTY with hold-tap on Q (Esc) and P (Backspace)
#define BASE_LAYER \
'@ + $base + @'^


// Numbers Layer - Numbers, F-keys, Navigation
#define NUM_LAYER \
'@ + $num + @'^


// Symbols Layer - All symbols and brackets
#define SYM_LAYER \
'@ + $sym + @'^


// Adjust Layer - Bluetooth, system controls, media
#define ADJ_LAYER \
'@ + $adj; ^
Set-Content -Path '%DTSI_3X5%' -Value $output -NoNewline"

if %ERRORLEVEL% NEQ 0 (
    echo [31m❌ Error: Failed to process 3x5 layers[0m
    exit /b 1
)

echo    [32m✅ Created %DTSI_3X5%[0m
echo.

echo [36m📝 Step 2: Syncing 3x6 layers from %KEYMAP_3X6%...[0m

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"function Extract-Layer($content, $layerName) { ^
    if ($content -match \"(?s)$layerName \{.*?bindings = <(.*?)>;\" ) { ^
        $bindings = $matches[1].Trim() -split \"`n\" ^| ForEach-Object { $_.Trim() } ^| Where-Object { $_ -ne '' }; ^
        return ($bindings -join \" \\`n\"); ^
    } ^
    return ''; ^
} ^
$keymap3x6 = Get-Content '%KEYMAP_3X6%' -Raw; ^
$base = Extract-Layer $keymap3x6 'base_layer'; ^
$num = Extract-Layer $keymap3x6 'num_layer'; ^
$sym = Extract-Layer $keymap3x6 'sym_layer'; ^
$adj = Extract-Layer $keymap3x6 'adj_layer'; ^
$output = @'^
/*
 * Generic 3x6 Layer Definitions
 * 
 * This file is auto-generated from generic_3x6.keymap
 * Edit generic_3x6.keymap with keymap-editor, then run: scripts\sync_all_generic_layers.bat
 * 
 * Uses the same macro names as 3x5 for consistency
 * 
 * Layout: 3 rows of 6 keys per side + 3 thumb keys per side = 42 keys
 */

// Base Layer - QWERTY with outer columns
#define BASE_LAYER \
'@ + $base + @'^


// Numbers Layer - Numbers, F-keys, Navigation
#define NUM_LAYER \
'@ + $num + @'^


// Symbols Layer - All symbols and brackets
#define SYM_LAYER \
'@ + $sym + @'^


// Adjust Layer - Bluetooth, system controls, media
#define ADJ_LAYER \
'@ + $adj; ^
Set-Content -Path '%DTSI_3X6%' -Value $output -NoNewline"

if %ERRORLEVEL% NEQ 0 (
    echo [31m❌ Error: Failed to process 3x6 layers[0m
    exit /b 1
)

echo    [32m✅ Created %DTSI_3X6%[0m
echo.

echo [32m✅ Successfully synced all generic layers![0m
echo.
echo [36m📋 Summary:[0m
echo    3x5 Layers:
echo       - BASE_LAYER
echo       - NUM_LAYER
echo       - SYM_LAYER
echo       - ADJ_LAYER
echo.
echo    3x6 Layers (same names as 3x5):
echo       - BASE_LAYER
echo       - NUM_LAYER
echo       - SYM_LAYER
echo       - ADJ_LAYER
echo.
echo [32m🚀 All boards using these .dtsi files will get the changes on next build![0m

endlocal

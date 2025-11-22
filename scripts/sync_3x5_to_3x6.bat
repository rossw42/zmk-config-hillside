@echo off
REM Sync 3x5 Core to 3x6
REM 
REM This script automatically syncs core keys from generic_3x5.keymap to generic_3x6.keymap
REM 
REM Mapping:
REM - Core 3x5 alpha keys stay the same
REM - 3x5 thumbs (2 per side) → 3x6 middle thumbs (outer 2 of 3)
REM - Outer columns: Tab/Ctrl/Shift (left), Bspc/'/Shift (right)
REM - Extra thumb: Tab (left), GUI (right)
REM
REM Usage: scripts\sync_3x5_to_3x6.bat

setlocal enabledelayedexpansion

set KEYMAP_3X5=config\generic_3x5.keymap
set KEYMAP_3X6=config\generic_3x6.keymap
set TEMP_FILE=%TEMP%\zmk_sync_%RANDOM%.tmp

echo [33m🔄 Syncing 3x5 core keys to 3x6...[0m
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

echo [36m📝 Extracting and converting layers...[0m

REM Note: This is a simplified version for Windows
REM For full functionality, use Git Bash or WSL on Windows
REM This version requires PowerShell for text processing

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$keymap3x5 = Get-Content '%KEYMAP_3X5%' -Raw; ^
$keymap3x6 = Get-Content '%KEYMAP_3X6%' -Raw; ^
function Extract-Layer($content, $layerName) { ^
    if ($content -match \"(?s)$layerName \{.*?bindings = <(.*?)>;\" ) { ^
        return $matches[1].Trim() -split \"`n\" ^| ForEach-Object { $_.Trim() } ^| Where-Object { $_ -ne '' }; ^
    } ^
    return @(); ^
} ^
function Convert-To3x6($rows, $leftOuter, $rightOuter, $leftThumb, $rightThumb) { ^
    $result = @(); ^
    $result += \"$($leftOuter[0])  $($rows[0])  $($rightOuter[0])\"; ^
    $result += \"$($leftOuter[1])  $($rows[1])  $($rightOuter[1])\"; ^
    $result += \"$($leftOuter[2])  $($rows[2])  $($rightOuter[2])\"; ^
    $result += \"                                       $leftThumb  $($rows[3])  $rightThumb\"; ^
    return $result; ^
} ^
$base3x5 = Extract-Layer $keymap3x5 'base_layer'; ^
$num3x5 = Extract-Layer $keymap3x5 'num_layer'; ^
$sym3x5 = Extract-Layer $keymap3x5 'sym_layer'; ^
$adj3x5 = Extract-Layer $keymap3x5 'adj_layer'; ^
$base3x6 = Convert-To3x6 $base3x5 @('&kp TAB','&kp LCTRL','&kp LSHFT') @('&kp BSPC','&kp SQT','&kp RSHFT') '&kp TAB' '&kp LGUI'; ^
$num3x6 = Convert-To3x6 $num3x5 @('&kp ESC','&kp F11','&kp F12') @('&kp DEL','&kp TAB','&kp INS') '&trans' '&trans'; ^
$sym3x6 = Convert-To3x6 $sym3x5 @('&kp TILDE','&kp LSHFT','&kp LSHFT') @('&kp BSPC','&kp SQT','&kp RSHFT') '&trans' '&trans'; ^
$adj3x6 = Convert-To3x6 $adj3x5 @('&none','&none','&bootloader') @('&none','&none','&none') '&none' '&none'; ^
$header = @'^
/*
 * Generic 3x6 Keymap
 * 
 * AUTO-SYNCED from generic_3x5.keymap
 * Core keys are synced automatically - outer columns defined here
 * 
 * Edit generic_3x5.keymap, then run: scripts\sync_3x5_to_3x6.bat
 */

#include <behaviors.dtsi>
#include <dt-bindings/zmk/bt.h>
#include <dt-bindings/zmk/ext_power.h>
#include <dt-bindings/zmk/keys.h>
#include <dt-bindings/zmk/outputs.h>

/ {
    behaviors {
        esc_q: escape_q {
            compatible = \"zmk,behavior-hold-tap\";
            #binding-cells = <2>;
            flavor = \"tap-preferred\";
            tapping-term-ms = <200>;
            quick-tap-ms = <150>;
            bindings = <&kp>, <&kp>;
        };
        
        bspc_p: backspace_p {
            compatible = \"zmk,behavior-hold-tap\";
            #binding-cells = <2>;
            flavor = \"tap-preferred\";
            tapping-term-ms = <200>;
            quick-tap-ms = <150>;
            bindings = <&kp>, <&kp>;
        };
    };

    combos {
        compatible = \"zmk,combos\";

        combo_unlock {
            timeout-ms = <50>;
            key-positions = <0 1>;
            bindings = <&studio_unlock>;
            layers = <0>;
        };

        combo_adj {
            timeout-ms = <200>;
            key-positions = <36 41>;
            bindings = <&mo 3>;
        };
    };

    keymap {
        compatible = \"zmk,keymap\";

        base_layer {
            display-name = \"Base\";
            bindings = <
'@; ^
$footer = @'^
            >;
        };
    };
};
'@; ^
$output = $header + ($base3x6 -join \"`n\") + \"`n            >;\`n        };\`n\`n        num_layer {\`n            display-name = \`\"Numbers\`\";\`n            bindings = <\`n\" + ($num3x6 -join \"`n\") + \"`n            >;\`n        };\`n\`n        sym_layer {\`n            display-name = \`\"Symbols\`\";\`n            bindings = <\`n\" + ($sym3x6 -join \"`n\") + \"`n            >;\`n        };\`n\`n        adj_layer {\`n            display-name = \`\"Adjust\`\";\`n            bindings = <\`n\" + ($adj3x6 -join \"`n\") + $footer; ^
Set-Content -Path '%TEMP_FILE%' -Value $output -NoNewline"

if %ERRORLEVEL% NEQ 0 (
    echo [31m❌ Error: Failed to process keymaps[0m
    exit /b 1
)

REM Replace the 3x6 keymap
move /Y "%TEMP_FILE%" "%KEYMAP_3X6%" >nul

echo    [32m✅ Updated %KEYMAP_3X6%[0m
echo.
echo [32m✅ Successfully synced 3x5 → 3x6![0m
echo.
echo [36m📋 Next steps:[0m
echo    1. Review %KEYMAP_3X6% to verify outer columns
echo    2. Run: scripts\sync_all_generic_layers.bat
echo    3. Commit and build!

endlocal

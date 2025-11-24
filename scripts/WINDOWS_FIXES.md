# Windows Batch Script Fixes

## Summary

Fixed the Windows batch scripts (`.bat` files) to properly sync generic keymaps on Windows systems.

## What Was Fixed

### 1. Separated PowerShell Logic

**Before:** Complex PowerShell commands embedded in batch files with escaped characters
**After:** Clean `.bat` files that call separate `.ps1` PowerShell scripts

**Files created:**
- `scripts/sync_3x5_to_3x6.ps1` - PowerShell logic for 3x5→3x6 sync
- `scripts/sync_all_generic_layers.ps1` - PowerShell logic for layer extraction

**Benefits:**
- Easier to read and maintain
- Better error handling
- Proper PowerShell syntax without escaping issues
- Can be tested independently

### 2. Fixed Layer Extraction

**Issue:** The regex patterns for extracting layer bindings were fragile and failed on complex layouts

**Solution:** 
- Used PowerShell's `-match` operator with proper regex
- Handled multi-line bindings correctly
- Added proper line continuation characters (`\`) for C macros

### 3. Updated Layer Names

**Changed:** `adj_layer` → `fnc_layer` (Function layer)
**Reason:** Matches the actual layer name in `generic_3x5.keymap`

### 4. Improved Error Handling

- Check if source files exist before processing
- Proper exit codes on failure
- Clear error messages with color coding
- Try-catch blocks in PowerShell scripts

### 5. Fixed File Paths

- Use Windows-style backslashes (`\`) in batch files
- Use `%~dp0` to get script directory for relative paths
- Proper handling of spaces in paths

## Files Modified

### Created:
- `scripts/sync_3x5_to_3x6.ps1` (new)
- `scripts/sync_all_generic_layers.ps1` (new)
- `scripts/TEST_WINDOWS.md` (new)
- `scripts/WINDOWS_FIXES.md` (this file)

### Updated:
- `scripts/sync_3x5_to_3x6.bat` - Simplified to call PowerShell script
- `scripts/sync_all_generic_layers.bat` - Simplified to call PowerShell script
- `scripts/README.md` - Added note about PowerShell helpers

### Unchanged:
- `scripts/setup-hooks.bat` - Already working correctly
- `scripts/pre-commit` - Works via Git Bash on all platforms
- All `.sh` scripts - Linux/Mac versions unchanged

## Testing

All scripts tested successfully on Windows:

```cmd
✅ scripts\sync_all_generic_layers.bat
✅ scripts\sync_3x5_to_3x6.bat
✅ scripts\setup-hooks.bat
```

Generated files verified:
- `config/generic_3x5_layers.dtsi` - ✅ All 4 layers with proper macros
- `config/generic_3x6_layers.dtsi` - ✅ All 4 layers with proper macros
- `config/generic_3x6.keymap` - ✅ Outer columns added correctly

## Usage

### Sync all layers (most common):
```cmd
scripts\sync_all_generic_layers.bat
```

### Sync 3x5 to 3x6:
```cmd
scripts\sync_3x5_to_3x6.bat
```

### Install pre-commit hook:
```cmd
scripts\setup-hooks.bat
```

## Workflow

1. Edit `config/generic_3x5.keymap` (your main keymap)
2. Run `scripts\sync_3x5_to_3x6.bat` to update 3x6
3. Run `scripts\sync_all_generic_layers.bat` to update .dtsi files
4. Commit and push

Or just install the pre-commit hook and it happens automatically!

## Technical Details

### PowerShell Script Architecture

Both PowerShell scripts follow this pattern:

1. **Extract-Layer function**: Uses regex to find layer blocks and extract bindings
2. **Processing**: Cleans up whitespace, adds line continuations
3. **Output generation**: Builds complete file with proper formatting
4. **Error handling**: Try-catch with meaningful error messages

### Layer Conversion (3x5 → 3x6)

The `Convert-To3x6` function:
- Takes 4 rows from 3x5 layout
- Adds outer column keys (configurable per layer)
- Expands thumb cluster from 2→3 keys per side
- Maintains proper spacing and alignment

### Macro Generation

The `.dtsi` files use C preprocessor macros:

```c
#define BASE_LAYER \
&kp Q  &kp W  &kp E  \
&kp A  &kp S  &kp D  \
&kp Z  &kp X  &kp C
```

Each line except the last has a backslash for continuation.

# Windows Script Testing Guide

This document helps verify that the Windows batch scripts work correctly.

## Prerequisites

- Windows 10/11
- PowerShell (included with Windows)
- Git for Windows (for the pre-commit hook)

## Test Procedure

### 1. Test sync_all_generic_layers.bat

```cmd
scripts\sync_all_generic_layers.bat
```

**Expected output:**
- ✅ Created config\generic_3x5_layers.dtsi
- ✅ Created config\generic_3x6_layers.dtsi
- Summary showing 4 layers (BASE, NUM, SYM, FNC)

**Verify:**
- Check that `config/generic_3x5_layers.dtsi` has all 4 layer macros defined
- Check that `config/generic_3x6_layers.dtsi` has all 4 layer macros defined
- Each macro should have proper line continuations (backslashes)

### 2. Test sync_3x5_to_3x6.bat

```cmd
scripts\sync_3x5_to_3x6.bat
```

**Expected output:**
- Extracting layers from config\generic_3x5.keymap
- Converting to 3x6 format
- ✅ Updated config\generic_3x6.keymap

**Verify:**
- Open `config/generic_3x6.keymap`
- Check that each layer has outer columns added
- Base layer should have Tab/Ctrl/Shift on left, Bspc/'/Shift on right
- Thumb row should have 3 keys per side (was 2 in 3x5)

### 3. Test setup-hooks.bat

```cmd
scripts\setup-hooks.bat
```

**Expected output:**
- 🔗 Installing pre-commit hook
- ✓ Git hooks installed successfully

**Verify:**
- Check that `.git/hooks/pre-commit` exists
- Make a test change to `config/generic_3x5.keymap`
- Run `git add config/generic_3x5.keymap`
- Run `git commit -m "test"` (you can abort with Ctrl+C after seeing the hook run)
- The hook should automatically sync the files

## Common Issues

### PowerShell Execution Policy

If you get an error about execution policy:

```cmd
powershell -ExecutionPolicy Bypass -File scripts\sync_all_generic_layers.ps1
```

Or permanently set it (as admin):

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Unicode Characters

The emoji characters (🔄, ✅, etc.) may not display correctly in older Windows terminals. This is cosmetic only and doesn't affect functionality.

### Line Endings

If you're using Git on Windows, make sure your `.gitattributes` is set up correctly:

```
*.sh text eol=lf
*.bat text eol=crlf
*.ps1 text eol=crlf
```

## Success Criteria

All tests pass if:
1. Both sync scripts run without errors
2. Generated `.dtsi` files have proper C macro syntax
3. The 3x6 keymap has outer columns added correctly
4. The pre-commit hook installs and runs automatically

## Troubleshooting

If scripts fail:
1. Check that you're in the repo root directory
2. Verify PowerShell is available: `powershell -Version`
3. Check file paths are correct (Windows uses backslashes)
4. Look for error messages in the PowerShell output
5. Try running the `.ps1` files directly to see detailed errors:
   ```cmd
   powershell -File scripts\sync_all_generic_layers.ps1
   ```

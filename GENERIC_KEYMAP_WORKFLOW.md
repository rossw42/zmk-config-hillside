# Generic Keymap Workflow

This repo uses a shared keymap system for 3x5 keyboards (a_dux, cradio36, etc.)

## The System

**3x5 System:**
- **`config/generic_3x5.keymap`** - Edit this with keymap-editor
- **`config/generic_3x5_layers.dtsi`** - Auto-generated layer definitions
- **Board keymaps** (a_dux.keymap, cradios.keymap) - Include the .dtsi automatically

**3x6 System:**
- **`config/generic_3x6.keymap`** - Edit this with keymap-editor (or auto-sync from 3x5)
- **`config/generic_3x6_layers.dtsi`** - Auto-generated layer definitions
- **Board keymaps** (corne.keymap) - Include the .dtsi automatically

## Setup (One Time)

Install the pre-commit hook to automatically sync keymaps:

```bash
./scripts/setup-hooks.sh
```

This ensures your keymaps are always in sync before committing!

## Workflow

### For 3x5 Boards (a_dux, cradios, etc.)

1. **Edit with keymap-editor:**
   ```
   Edit: config/generic_3x5.keymap
   ```

2. **Commit and build:**
   ```bash
   git add config/generic_3x5.keymap
   git commit -m "Update 3x5 keymap"
   git push
   ```
   
   The pre-commit hook automatically:
   - Syncs 3x5 → 3x6
   - Updates all .dtsi files
   - Adds them to your commit

### For 3x6 Boards (corne, etc.)

**Option A: Edit 3x5 and auto-sync (recommended)**
1. Edit `config/generic_3x5.keymap`
2. Commit - the hook syncs to 3x6 automatically!

**Option B: Edit 3x6 directly**
1. Edit `config/generic_3x6.keymap` 
2. Commit - the hook syncs to .dtsi files

### Manual Sync (if needed)

If you want to sync without committing:

```bash
# Sync 3x5 → 3x6
./scripts/sync_3x5_to_3x6.sh

# Sync both to .dtsi
./scripts/sync_all_generic_layers.sh
```

## How It Works

The pre-commit hook automatically:
- Syncs core 3x5 keys → 3x6 (with outer columns)
- Updates all .dtsi files
- Adds synced files to your commit

**What gets synced:**
- Core 3x5 alpha keys → Same position in 3x6
- Thumb mapping: 2 thumbs → 3 thumbs (adds Tab/GUI)
- Outer columns: Tab/Ctrl/Shift (left), Bspc/'/Shift (right)

**To bypass the hook temporarily:**
```bash
git commit --no-verify
```

## Which Boards Use This?

**3x5 boards** using `generic_3x5_layers.dtsi`:
- ✅ a_dux (34 keys, 2 thumbs)
- ✅ cradios (34 keys, 2 thumbs)

**3x6 boards** using `generic_3x6_layers.dtsi`:
- ✅ corne (42 keys, 3x6 + 3 thumbs)
- ✅ cradio36 (36 keys, 3x5 + 3 thumbs, no outer columns)

**Custom keymaps** (not using generic system):
- ⏳ hillside48 (48 keys, 3x6 + 4 thumbs + extras) - too custom
- ⏳ corne_left-single (one-handed) - special layout

## Adding a New Board

To make a board use the generic layout:

1. Add the behaviors and combos to your board's keymap
2. Replace layer bindings with macros:
   ```c
   #include <behaviors.dtsi>
   // ... other includes ...
   
   / {
       // ... behaviors and combos ...
       
       keymap {
           base_layer {
               bindings = < BASE_LAYER >;
           };
           num_layer {
               bindings = < NUM_LAYER >;
           };
           // ... etc
       };
   };
   
   #include "generic_3x5_layers.dtsi"
   ```

3. Done! The board now uses the shared layout.

## Benefits

- ✅ Edit once, update all boards
- ✅ Use keymap-editor for visual editing
- ✅ Keep board-specific customizations separate
- ✅ Version controlled and shareable

## Testing

The `generic_3x5` shield is a virtual board for testing:
- Build it to verify your keymap compiles
- Use it with keymap-editor
- Changes sync to real boards via the script

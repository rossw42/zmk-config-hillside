# Generic Keymap Workflow

This repo uses a shared keymap system for 3x5 keyboards (a_dux, cradio36, etc.)

## The System

- **`config/generic_3x5.keymap`** - Edit this with keymap-editor
- **`config/generic_3x5_layers.dtsi`** - Auto-generated layer definitions
- **Board keymaps** (a_dux.keymap, etc.) - Include the .dtsi automatically

## Workflow

### 1. Edit Your Keymap

Use [keymap-editor](https://nickcoutsos.github.io/keymap-editor/) to edit:
```
config/generic_3x5.keymap
```

Make your changes and commit them to your repo.

### 2. Sync to All Boards

Run the sync script:
```bash
./scripts/sync_generic_layers.sh
```

This extracts the bindings from `generic_3x5.keymap` and updates `generic_3x5_layers.dtsi`.

### 3. Build & Flash

Commit the changes and push:
```bash
git add config/
git commit -m "Update keymap"
git push
```

GitHub Actions will build firmware for all boards that include the generic layout.

## Which Boards Use This?

Currently using `generic_3x5_layers.dtsi`:
- ✅ a_dux (34 keys)
- ⏳ cradio36 (36 keys) - needs setup
- ⏳ Other 3x5 boards - needs setup

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

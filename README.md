# ZMK Config - Multi-Board Split Ergo Keyboards

[![Build](https://github.com/rossw42/zmk-config-hillside/actions/workflows/build.yml/badge.svg)](https://github.com/rossw42/zmk-config-hillside/actions/workflows/build.yml)

This is a [ZMK](https://zmk.dev/docs) firmware configuration for multiple split ergonomic keyboards using a **unified generic keymap system**.

## Keyboards

| Board | Keys | Generic System | Notes |
|-------|------|----------------|-------|
| **a_dux** | 34 (3x5+2) | ✅ 3x5 | ZMK Studio enabled |
| **cradio** | 34 (3x5+2) | ✅ 3x5 | Clean generic layout |
| **corne** | 42 (3x6+3) | ✅ 3x6 | ZMK Studio enabled |
| **hillside48** | 48 (3x6+4+extras) | ✅ 3x6 | ZMK Studio enabled, extra keys customized |
| **cradio-adv** | 34 (3x5+2) | ❌ Custom | Mouse support, custom macros, Colemak toggle |
| **cradios** | 34 (3x5+2) | ❌ Custom | Basic hardcoded layout |
| **cradio36** | 36 (3x5+3) | ❌ Custom | Hardcoded layout |

**Generic System:** Boards marked ✅ automatically sync from `generic_3x5.keymap` or `generic_3x6.keymap`

## Generic Keymap System

Edit **one** keymap file and all compatible boards get the update automatically!

### Quick Start

1. **Setup (one time):**
   
   Mac/Linux:
   ```bash
   ./scripts/setup-hooks.sh
   ```
   
   Windows:
   ```batch
   scripts\setup-hooks.bat
   ```

2. **Edit your keymap:**
   - Edit `config/generic_3x5.keymap` directly in your editor

3. **Commit and push:**
   ```bash
   git add config/generic_3x5.keymap
   git commit -m "Update keymap"
   git push
   ```

The pre-commit hook automatically:
- Syncs 3x5 → 3x6 (adds outer columns)
- Updates all .dtsi layer definitions
- Adds synced files to your commit

All 5 boards get your keymap changes! 🚀

### How It Works

- **Core layout** defined in `config/generic_3x5.keymap`
- **Auto-synced** to `config/generic_3x6.keymap` (with outer columns)
- **Layer definitions** extracted to `.dtsi` files
- **Board keymaps** include the `.dtsi` files automatically

See [GENERIC_KEYMAP_WORKFLOW.md](GENERIC_KEYMAP_WORKFLOW.md) for detailed documentation.

## Building Firmware

### GitHub Actions (Automatic)

Push changes to trigger a build:

1. Make changes to your keymap
2. Commit and push
3. Check the [Actions](https://github.com/rossw42/zmk-config-hillside/actions) tab
4. Download firmware artifacts when build completes

### Local Build

```bash
# Install dependencies (one time)
# See: https://zmk.dev/docs/development/setup

# Build for a specific board
west build -s zmk/app -b nice_nano_v2 -- -DSHIELD=a_dux_left
```

## File Structure

```
config/
├── generic_3x5.keymap          # Edit this - core 3x5 layout
├── generic_3x6.keymap          # Auto-synced from 3x5
├── generic_3x5_layers.dtsi     # Auto-generated layer definitions
├── generic_3x6_layers.dtsi     # Auto-generated layer definitions
├── a_dux.keymap                # Includes generic_3x5_layers.dtsi
├── cradios.keymap              # Includes generic_3x5_layers.dtsi
├── corne.keymap                # Includes generic_3x6_layers.dtsi
├── cradio36.keymap             # Includes generic_3x6_layers.dtsi
└── hillside48.keymap           # Includes generic_3x6_layers.dtsi

scripts/
├── setup-hooks.sh              # Install pre-commit hook
├── pre-commit                  # Auto-sync on commit
├── sync_3x5_to_3x6.sh         # Manual: sync 3x5 → 3x6
└── sync_all_generic_layers.sh  # Manual: sync to .dtsi files

boards/shields/
├── a_dux/                      # Shield definitions
├── cradios/
├── cradio36/
├── hillside48/
└── ...
```

## Customization

### Board-Specific Changes

Each board's keymap can be customized while still using the generic core:

- **a_dux.keymap** - Modify behaviors, combos, or add board-specific keys
- **hillside48.keymap** - Has extra keys (CAPS, ESC, 4th thumb) that can be customized

### Features

Enable features in board-specific `.conf` files:

```
# config/a_dux.conf
CONFIG_ZMK_RGB_UNDERGLOW=y
CONFIG_ZMK_SLEEP=y
```

## Advanced Usage

### Manual Sync (Without Committing)

If you want to sync without committing:

Mac/Linux:
```bash
# Sync 3x5 → 3x6
./scripts/sync_3x5_to_3x6.sh

# Sync both to .dtsi
./scripts/sync_all_generic_layers.sh
```

Windows:
```batch
REM Sync 3x5 → 3x6
scripts\sync_3x5_to_3x6.bat

REM Sync both to .dtsi
scripts\sync_all_generic_layers.bat
```

### Bypass Pre-commit Hook

To commit without running the sync hook:

```bash
git commit --no-verify
```

### Adding a New Board

To make a board use the generic layout:

1. **Include the layer definitions:**
   ```c
   #include <behaviors.dtsi>
   #include <dt-bindings/zmk/keys.h>
   // ... other includes ...
   
   // Include BEFORE the device tree node
   #include "generic_3x5_layers.dtsi"  // or generic_3x6_layers.dtsi
   
   / {
       behaviors {
           // Define esc_q and bspc_p if using them
       };
       
       combos {
           // Your combos
       };
       
       keymap {
           base_layer {
               bindings = < BASE_LAYER >;
           };
           num_layer {
               bindings = < NUM_LAYER >;
           };
           sym_layer {
               bindings = < SYM_LAYER >;
           };
           adj_layer {
               bindings = < ADJ_LAYER >;
           };
       };
   };
   ```

2. **Add to build.yaml:**
   ```yaml
   - board: nice_nano_v2
     shield: your_board_left
   ```

3. Done! The board now uses the shared layout.

## How The Sync Works

**What gets synced automatically:**
- Core 3x5 alpha keys → Same position in 3x6
- Thumb mapping: 2 thumbs → 3 thumbs (adds Tab/GUI)
- Outer columns: Tab/Ctrl/Shift (left), Bspc/'/Shift (right)

**The pre-commit hook:**
1. Extracts bindings from `generic_3x5.keymap`
2. Adds outer columns and expands to 3x6
3. Generates `.dtsi` macro definitions
4. Stages synced files in your commit

## Scripts

All scripts have both Mac/Linux (`.sh`) and Windows (`.bat`) versions:

- `setup-hooks` - Install pre-commit hook (one time)
- `sync_3x5_to_3x6` - Manually sync 3x5 → 3x6
- `sync_all_generic_layers` - Manually sync to .dtsi files

See [scripts/README.md](scripts/README.md) for details.

## Troubleshooting

**Build fails with "parse error":**
- Run `./scripts/sync_all_generic_layers.sh` to regenerate .dtsi files
- Check that `.dtsi` files don't have extra backslashes

**Changes not syncing:**
- Make sure pre-commit hook is installed (run setup-hooks script)
- Mac/Linux: Check hook is executable: `ls -la .git/hooks/pre-commit`
- Windows: The pre-commit hook works via Git Bash (included with Git for Windows)

**ZMK Studio not working:**
- Only a_dux, corne, and hillside48 have Studio support
- Other boards need physical layout definitions added to their shields

## Resources

- [ZMK Documentation](https://zmk.dev/docs)
- [ZMK Studio](https://zmk.dev/docs/features/studio)
- [Hillside Keyboards](https://github.com/mmccoyd/hillside)

## License

MIT

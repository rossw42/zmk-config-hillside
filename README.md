# ZMK Config - Multi-Board Split Ergo Keyboards

[![Build](https://github.com/rossw42/zmk-config-hillside/actions/workflows/build.yml/badge.svg)](https://github.com/rossw42/zmk-config-hillside/actions/workflows/build.yml)

This is a [ZMK](https://zmk.dev/docs) firmware configuration for multiple split ergonomic keyboards using a **unified generic keymap system**.

## Keyboards

This config supports 5 keyboards with automatic keymap syncing:

**3x5 Boards (34 keys):**
- ✅ a_dux (3x5 + 2 thumbs) - with ZMK Studio
- ✅ cradios (3x5 + 2 thumbs)

**3x6 Boards (36-48 keys):**
- ✅ corne (3x6 + 3 thumbs) - with ZMK Studio
- ✅ cradio36 (3x5 + 3 thumbs, no outer columns)
- ✅ hillside48 (3x6 + 4 thumbs + extras) - with ZMK Studio

## Generic Keymap System

Edit **one** keymap file and all compatible boards get the update automatically!

### Quick Start

1. **Setup (one time):**
   ```bash
   ./scripts/setup-hooks.sh
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

## Scripts

- `./scripts/setup-hooks.sh` - Install pre-commit hook (one time)
- `./scripts/sync_3x5_to_3x6.sh` - Manually sync 3x5 → 3x6
- `./scripts/sync_all_generic_layers.sh` - Manually sync to .dtsi files

See [scripts/README.md](scripts/README.md) for details.

## Resources

- [ZMK Documentation](https://zmk.dev/docs)
- [ZMK Studio](https://zmk.dev/docs/features/studio)
- [Generic Keymap Workflow](GENERIC_KEYMAP_WORKFLOW.md)
- [Hillside Keyboards](https://github.com/mmccoyd/hillside)

## License

MIT

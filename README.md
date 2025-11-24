# ZMK Config - rossw42

[![Build](https://github.com/rossw42/zmk-config-rossw42/actions/workflows/build.yml/badge.svg)](https://github.com/rossw42/zmk-config-rossw42/actions/workflows/build.yml)

Personal [ZMK](https://zmk.dev) firmware configuration for multiple split ergonomic keyboards using a unified generic keymap system.

## 🎯 Quick Start

### 1. Edit Your Keymap

Edit the master keymap file:
```
config/generic_3x5.keymap
```

### 2. Commit & Push

```bash
git add config/generic_3x5.keymap
git commit -m "Update keymap"
git push
```

### 3. Download Firmware

Check the [Actions](https://github.com/rossw42/zmk-config-rossw42/actions) tab and download the firmware artifacts.

**That's it!** All compatible boards automatically get your changes.

## 🎹 Keyboards

| Board | Layout | Status | Notes |
|-------|--------|--------|-------|
| **a_dux** | 3x5+2 (34 keys) | ✅ Active | ZMK Studio enabled |
| **hillside48** | 3x6+extras (48 keys) | 🚧 Planned | ZMK Studio support |
| **corne** | 3x6+3 (42 keys) | 🚧 Planned | Popular 3x6 board |

## 🔄 Generic Keymap System

**One keymap to rule them all!**

- Edit `generic_3x5.keymap` once
- Automatically syncs to `generic_3x6.keymap` (adds outer columns)
- All boards using the generic system get updated
- No code duplication

### How It Works

```
generic_3x5.keymap (you edit this)
       ↓
   [sync scripts]
       ↓
   ┌───┴────┐
   ↓        ↓
3x5 boards  3x6 boards
(a_dux)     (hillside48, corne)
```

### Setup Auto-Sync (Optional)

Install the pre-commit hook to automatically sync on every commit:

**Windows:**
```cmd
scripts\setup-hooks.bat
```

**Mac/Linux:**
```bash
./scripts/setup-hooks.sh
```

Now just edit and commit - syncing happens automatically!

## 📁 Repository Structure

```
├── config/
│   ├── generic_3x5.keymap              # 👈 Edit this
│   ├── generic_3x5_behaviors.dtsi      # Shared behaviors/macros
│   ├── generic_3x5_layers.dtsi         # Auto-generated layers
│   ├── generic_3x6.keymap              # Auto-synced from 3x5
│   ├── generic_3x6_layers.dtsi         # Auto-generated layers
│   └── a_dux.keymap                    # Board-specific config
│
├── boards/shields/                     # Board definitions
│   ├── a_dux/
│   └── hillside48/
│
├── scripts/                            # Automation scripts
│   ├── setup-hooks.bat/.sh            # Install pre-commit hook
│   ├── sync_3x5_to_3x6.bat/.sh        # Manual sync 3x5→3x6
│   └── sync_all_generic_layers.bat/.sh # Manual sync to .dtsi
│
└── docs/                               # Documentation
    ├── GENERIC_KEYMAP_SYSTEM.md       # Detailed system docs
    └── SCRIPTS.md                      # Script documentation
```

## 🛠️ Manual Sync (Without Committing)

If you don't want to use the pre-commit hook:

**Windows:**
```cmd
scripts\sync_3x5_to_3x6.bat
scripts\sync_all_generic_layers.bat
```

**Mac/Linux:**
```bash
./scripts/sync_3x5_to_3x6.sh
./scripts/sync_all_generic_layers.sh
```

## 🎨 Features

### Shared Across All Boards
- **Homerow mods** - Tap for letter, hold for modifier
- **4 layers** - Base (QWERTY), Numbers, Symbols, Function
- **Smart behaviors** - Optimized hold-tap timings
- **Vim macros** - Quick `:q!` and `:x` shortcuts
- **Combos** - Arrow keys, volume control, shortcuts

### Board-Specific
Each board can customize:
- Extra keys (hillside48 has CAPS, ESC, extra thumbs)
- Combos and shortcuts
- RGB/display settings
- Power management

## 📚 Documentation

- **[Generic Keymap System](docs/GENERIC_KEYMAP_SYSTEM.md)** - How the system works
- **[Scripts Documentation](docs/SCRIPTS.md)** - Detailed script usage
- **[Windows Setup](docs/WINDOWS_FIXES.md)** - Windows-specific notes

## 🔧 Advanced Usage

### Adding a New Board

1. Create `config/yourboard.keymap`
2. Include the shared files:
   ```c
   #include "generic_3x5_behaviors.dtsi"
   #include "generic_3x5_layers.dtsi"
   ```
3. Use the layer macros:
   ```c
   base_layer {
       bindings = < BASE_LAYER >;
   }
   ```
4. Add to `build.yaml`

See [docs/GENERIC_KEYMAP_SYSTEM.md](docs/GENERIC_KEYMAP_SYSTEM.md) for details.

### Local Build

```bash
# Build for a specific board
west build -s zmk/app -b nice_nano_v2 -- -DSHIELD=a_dux_left

# Clean build
west build -t pristine
```

### Bypass Pre-commit Hook

```bash
git commit --no-verify
```

## 🐛 Troubleshooting

**Build fails with "undefined node label":**
- Make sure board keymap includes `generic_3x5_behaviors.dtsi`
- Run sync scripts to regenerate .dtsi files

**Changes not syncing:**
- Check pre-commit hook is installed: `ls -la .git/hooks/pre-commit`
- Or run sync scripts manually

**Windows scripts not working:**
- See [docs/TEST_WINDOWS.md](docs/TEST_WINDOWS.md) for troubleshooting

## 📝 License

MIT

## 🔗 Resources

- [ZMK Documentation](https://zmk.dev/docs)
- [ZMK Studio](https://zmk.dev/docs/features/studio)
- [Hillside Keyboards](https://github.com/mmccoyd/hillside)

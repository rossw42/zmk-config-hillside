# ZMK Config - rossw42

Personal [ZMK](https://zmk.dev) firmware configuration for multiple split ergonomic keyboards using a unified generic keymap system.

## 🔄 Generic Keymap System

**One keymap to rule them all!**

This config uses a shared keymap system to keep multiple boards in sync. Edit one file, and all compatible boards get updated automatically.

### Architecture

#### Core Files

1. **generic_3x5.keymap** - The master keymap (edit this with keymap-editor)
2. **generic_3x5_behaviors.dtsi** - Shared behaviors and macros
3. **generic_3x5_layers.dtsi** - Layer definitions (auto-generated)
4. **generic_3x6.keymap** - 3x6 version (auto-synced from 3x5)
5. **generic_3x6_layers.dtsi** - 3x6 layer definitions (auto-generated)

### How It Works

```
generic_3x5.keymap (you edit this)
       ↓
   [sync scripts]
       ↓
   ┌───┴────┐
   ↓        ↓
3x5_layers  3x6.keymap
   ↓            ↓
   ↓        [sync scripts]
   ↓            ↓
   ↓        3x6_layers
   ↓            ↓
   └────┬───────┘
        ↓
   Board keymaps include these
```

### Keymap Layout

[![Open in Keymap Editor](https://img.shields.io/badge/🎹_Open_in-Keymap_Editor-blue?style=for-the-badge)](https://nickcoutsos.github.io/keymap-editor/)

**To view the interactive keymap:**
1. Click the badge above
2. Connect your GitHub account
3. Select this repository
4. Explore all layers visually!

The generic 3x5 keymap uses a 34-key layout with 4 layers:

**Layer Overview:**

| Layer | Purpose | Access |
|-------|---------|--------|
| **Base** | QWERTY + Homerow Mods | Default |
| **Numbers** | Numbers, F-keys, Navigation | Hold right thumb (BSPC) |
| **Symbols** | All symbols & brackets | Hold left thumb (TAB) |
| **Function** | Bluetooth, Media, System | Combo: both outer thumbs |

**Key Features:**
- **Homerow Mods**: Hold A/S/D/F for Ctrl/Alt/GUI/Shift (left hand)
- **Homerow Mods**: Hold J/K/L/; for Shift/GUI/Alt/Ctrl (right hand)
- **Q = Esc** when held, Q when tapped
- **P = Backspace** when held, P when tapped
- **Combos**: Arrow keys, volume control, and shortcuts via key combinations

<details>
<summary>📋 Click to see detailed layer breakdown</summary>

```
BASE LAYER - QWERTY with Homerow Mods
╭─────────────────────────────────────────╮
│  Q    W    E    R    T    Y    U    I    O    P   │
│ Esc                                         Bspc  │
│  A    S    D    F    G    H    J    K    L    ;   │
│Ctrl  Alt  Gui  Shft            Shft  Gui  Alt Ctrl│
│  Z    X    C    V    B    N    M    ,    .    /   │
│              Tab   Ret       Spc   Bspc            │
│              ↓L2  Ctrl+Alt  Shft   ↓L1            │
╰─────────────────────────────────────────╯

LAYER 1 - Numbers & Navigation
╭─────────────────────────────────────────╮
│  1    2    3    4    5    6    7    8    9    0   │
│  F1   F2   F3   F4   F5   ←    ↓    ↑    →   Tab  │
│  F6   F7   F8   F9   F10  Home PgDn PgUp End  Del  │
│              ---  F11        F12  ---              │
╰─────────────────────────────────────────╯

LAYER 2 - Symbols
╭─────────────────────────────────────────╮
│  !    @    #    $    %    ^    &    *    (    )   │
│  `    ~    '    "    ---  -    =    [    ]    \   │
│  ---  ---  ---  ---  ---  _    +    {    }    |   │
│              ---  Esc        ---  ---              │
╰─────────────────────────────────────────╯

LAYER 3 - Function (Combo: both outer thumbs)
╭─────────────────────────────────────────╮
│Reset  --- --- BLE  BT0   ---  ---  ---  --- ---   │
│Boot   --- --- USB  BT1   ---  ---  ---  --- Boot  │
│ ---   --- --- BTClr BT2  Mute Play Prev Next ---  │
│              ---  ---        ---  ---              │
╰─────────────────────────────────────────╯
```

</details>

### What's Shared

#### Behaviors (generic_3x5_behaviors.dtsi)
- `esc_q` - Tap Q, hold Esc
- `bspc_p` - Tap P, hold Backspace
- `lmt` - Left hand homerow mods (Ctrl, Alt, GUI)
- `rmt` - Right hand homerow mods (GUI, Alt, Ctrl)
- `lst` - Left shift with tap-preferred
- `rst` - Right shift with tap-preferred

#### Macros (generic_3x5_behaviors.dtsi)
- `vim_q` - Types `:q!` for Vim
- `vim_s` - Types `:x` for Vim
- `dir_up` - Types `../` for navigation

#### Layers (generic_3x5_layers.dtsi)
- `BASE_LAYER` - QWERTY with homerow mods
- `NUM_LAYER` - Numbers, F-keys, navigation
- `SYM_LAYER` - Symbols and brackets
- `FNC_LAYER` - Bluetooth, system, media controls

### Benefits

✅ Edit once, update all boards  
✅ Consistent behavior across keyboards  
✅ Easy to maintain and test  
✅ Keymap-editor compatible  
✅ No code duplication  

## 🎯 Quick Start

### 1. Edit Your Keymap

Edit the master keymap file:
```
config/generic_3x5.keymap
```

You can edit it manually or use [keymap-editor](https://nickcoutsos.github.io/keymap-editor/).

### 2. Sync Changes

**Option A: Automatic (Recommended)**

Install the pre-commit hook to automatically sync on every commit:

**Windows:**
```cmd
scripts\setup-hooks.bat
```

**Mac/Linux:**
```bash
./scripts/setup-hooks.sh
```

Now just commit and the syncing happens automatically!

**Option B: Manual**

Run the sync scripts manually:

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

### 3. Commit & Push

```bash
git add .
git commit -m "Update keymap"
git push
```

### 4. Download Firmware

Check the [Actions](https://github.com/rossw42/zmk-config-rossw42/actions) tab and download the firmware artifacts when the build completes.

**That's it!** All compatible boards automatically get your changes.

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

## 🔧 Adding a New Board

Want to add another keyboard to use the generic system?

1. **Create board keymap** - `config/yourboard.keymap`

2. **Include the shared files:**
   ```c
   #include <behaviors.dtsi>
   #include <dt-bindings/zmk/keys.h>
   // ... other includes
   
   // Include shared behaviors FIRST
   #include "generic_3x5_behaviors.dtsi"
   
   // Include shared layers
   #include "generic_3x5_layers.dtsi"
   
   / {
       // Board-specific combos, settings, etc.
       
       keymap {
           compatible = "zmk,keymap";
           
           base_layer {
               bindings = < BASE_LAYER >;
           };
           
           num_layer {
               bindings = < NUM_LAYER >;
           };
           
           sym_layer {
               bindings = < SYM_LAYER >;
           };
           
           fnc_layer {
               bindings = < FNC_LAYER >;
           };
       };
   };
   ```

3. **Add to build.yaml:**
   ```yaml
   - board: nice_nano_v2
     shield: yourboard_left
   - board: nice_nano_v2
     shield: yourboard_right
   ```

4. **Done!** The board now uses the shared layout.

## 🎨 Customizing Per Board

### Different Behaviors

If a board needs custom behaviors:

1. Don't include `generic_3x5_behaviors.dtsi`
2. Define your own behaviors in the board keymap
3. Still include `generic_3x5_layers.dtsi` for the layers

### Different Layers

If a board needs completely custom layers:

1. Don't use the layer macros
2. Define layers directly in the board keymap
3. Or create board-specific layer files

### Board-Specific Features

Each board can customize:
- Extra keys (hillside48 has CAPS, ESC, extra thumbs)
- Combos and shortcuts
- RGB/display settings in `.conf` files
- Power management

## 🛠️ Advanced Usage

### Local Build

```bash
# Build for a specific board
west build -s zmk/app -b nice_nano_v2 -- -DSHIELD=a_dux_left

# Clean build
west build -t pristine
```

### Bypass Pre-commit Hook

To commit without running the sync hook:

```bash
git commit --no-verify
```

### Manual Sync Without Committing

If you want to test changes without committing:

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

## 🐛 Troubleshooting

**Build fails with "undefined node label 'lmt'":**
- Make sure board keymap includes `generic_3x5_behaviors.dtsi`
- This file must be included BEFORE `generic_3x5_layers.dtsi`

**Build fails with "parse error":**
- Run sync scripts to regenerate .dtsi files
- Check that `.dtsi` files don't have syntax errors

**Changes not syncing:**
- Check pre-commit hook is installed: `ls -la .git/hooks/pre-commit`
- Or run sync scripts manually

**Windows scripts not working:**
- Make sure PowerShell is available
- See [docs/SCRIPTS.md](docs/SCRIPTS.md) for troubleshooting

## 📚 Documentation

- **[Generic Keymap System](docs/GENERIC_KEYMAP_SYSTEM.md)** - Detailed system documentation
- **[Scripts Documentation](docs/SCRIPTS.md)** - Complete script usage guide

## 📝 License

MIT

## 🔗 Resources

- [ZMK Documentation](https://zmk.dev/docs)
- [ZMK Studio](https://zmk.dev/docs/features/studio)
- [Keymap Editor](https://nickcoutsos.github.io/keymap-editor/)
- [Hillside Keyboards](https://github.com/mmccoyd/hillside)

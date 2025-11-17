# ZMK Config Scripts

Automation scripts for managing generic keymaps across multiple boards.

## Setup

**Install the pre-commit hook (recommended):**
```bash
./scripts/setup-hooks.sh
```

This automatically syncs keymaps before each commit!

## Scripts

### `setup-hooks.sh`
Installs the pre-commit hook that automatically syncs keymaps.

**Usage:**
```bash
./scripts/setup-hooks.sh
```

### `pre-commit`
Git pre-commit hook that runs automatically before each commit.

**What it does:**
- Syncs 3x5 → 3x6 keymaps
- Updates .dtsi files
- Adds synced files to commit

**To bypass:**
```bash
git commit --no-verify
```

### `sync_3x5_to_3x6.sh`
Syncs core keys from generic_3x5.keymap to generic_3x6.keymap.

**Usage:**
```bash
./scripts/sync_3x5_to_3x6.sh
```

**What it does:**
- Extracts core 3x5 alpha keys
- Adds outer columns (Tab/Ctrl/Shift, Bspc/'/Shift)
- Expands 2-thumb to 3-thumb layout
- Updates generic_3x6.keymap

### `sync_all_generic_layers.sh`
Syncs keymap files to .dtsi layer definition files.

**Usage:**
```bash
./scripts/sync_all_generic_layers.sh
```

**What it does:**
- Extracts bindings from generic_3x5.keymap → generic_3x5_layers.dtsi
- Extracts bindings from generic_3x6.keymap → generic_3x6_layers.dtsi
- Board keymaps include these .dtsi files automatically

## Workflow

1. **Edit** `config/generic_3x5.keymap` with keymap-editor
2. **Commit** - the pre-commit hook handles the rest!
3. **Push** - GitHub Actions builds firmware for all boards

All boards (a_dux, cradios, corne) stay in sync automatically!

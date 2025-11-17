#!/bin/bash
# Sync Generic 3x5 Layers
# 
# This script extracts layer bindings from generic_3x5.keymap
# and updates generic_3x5_layers.dtsi so all boards get the changes
#
# Usage: ./scripts/sync_generic_layers.sh

set -e

KEYMAP_FILE="config/generic_3x5.keymap"
DTSI_FILE="config/generic_3x5_layers.dtsi"

echo "🔄 Syncing generic 3x5 layers..."

# Check if keymap file exists
if [ ! -f "$KEYMAP_FILE" ]; then
    echo "❌ Error: $KEYMAP_FILE not found"
    exit 1
fi

# Extract bindings from each layer
echo "📝 Extracting layer bindings from $KEYMAP_FILE..."

# Function to extract bindings for a layer
extract_layer() {
    local layer_name=$1
    local start_pattern="${layer_name} {"
    local end_pattern=">;$"
    
    # Extract the bindings between the layer declaration and the closing >;
    awk "/$start_pattern/,/$end_pattern/" "$KEYMAP_FILE" | \
        sed -n '/bindings = </,/>;/p' | \
        sed '1d;$d' | \
        sed 's/^[[:space:]]*//'
}

# Extract each layer
BASE_BINDINGS=$(extract_layer "base_layer")
NUM_BINDINGS=$(extract_layer "num_layer")
SYM_BINDINGS=$(extract_layer "sym_layer")
ADJ_BINDINGS=$(extract_layer "adj_layer")

# Create the new .dtsi file
cat > "$DTSI_FILE" << 'EOF'
/*
 * Generic 3x5 Layer Definitions
 * 
 * This file is auto-generated from generic_3x5.keymap
 * Edit generic_3x5.keymap with keymap-editor, then run: ./scripts/sync_generic_layers.sh
 * 
 * Include this file in your board's keymap to use the shared layout
 */

// Base Layer - QWERTY with hold-tap on Q (Esc) and P (Backspace)
#define BASE_LAYER \
EOF

# Add base layer bindings
echo "$BASE_BINDINGS" | sed 's/$/  \\/' | sed '$ s/ \\$//' >> "$DTSI_FILE"

cat >> "$DTSI_FILE" << 'EOF'

// Numbers Layer - Numbers, F-keys, Navigation
#define NUM_LAYER \
EOF

# Add num layer bindings
echo "$NUM_BINDINGS" | sed 's/$/  \\/' | sed '$ s/ \\$//' >> "$DTSI_FILE"

cat >> "$DTSI_FILE" << 'EOF'

// Symbols Layer - All symbols and brackets
#define SYM_LAYER \
EOF

# Add sym layer bindings
echo "$SYM_BINDINGS" | sed 's/$/  \\/' | sed '$ s/ \\$//' >> "$DTSI_FILE"

cat >> "$DTSI_FILE" << 'EOF'

// Adjust Layer - Bluetooth, system controls, media
#define ADJ_LAYER \
EOF

# Add adj layer bindings
echo "$ADJ_BINDINGS" | sed 's/$/  \\/' | sed '$ s/ \\$//' >> "$DTSI_FILE"

echo ""
echo "✅ Successfully synced layers to $DTSI_FILE"
echo ""
echo "📋 Summary:"
echo "   - BASE_LAYER updated"
echo "   - NUM_LAYER updated"
echo "   - SYM_LAYER updated"
echo "   - ADJ_LAYER updated"
echo ""
echo "🚀 All boards using generic_3x5_layers.dtsi will get these changes on next build!"

#!/usr/bin/env bash
set -euo pipefail

# Find the built-in audio device (Realtek ALC1150 on HDA Intel PCH)
DEVICE_ID=$(pw-dump | jq -r '.[] | select(.type == "PipeWire:Interface:Device") | select(.info.props."device.nick" == "HDA Intel PCH") | .id')

if [ -z "$DEVICE_ID" ] || [ "$DEVICE_ID" = "null" ]; then
    echo "Error: Built-in audio device (HDA Intel PCH) not found." >&2
    exit 1
fi

# Get current active output route
CURRENT=$(pw-dump | jq -r --arg dev "$DEVICE_ID" '
    .[] | select(.id == ($dev | tonumber)) | .info.params.Route // [] | .[] | select(.direction == "Output")
    | {name: .name, index: .index, device: .device}
')

CURRENT_NAME=$(echo "$CURRENT" | jq -r '.name')
CURRENT_DEVICE=$(echo "$CURRENT" | jq -r '.device')

if [ "$CURRENT_NAME" = "analog-output-lineout" ]; then
    TARGET_NAME="analog-output-headphones"
elif [ "$CURRENT_NAME" = "analog-output-headphones" ]; then
    TARGET_NAME="analog-output-lineout"
else
    echo "Current output is '$CURRENT_NAME'. Defaulting to Line Out." >&2
    TARGET_NAME="analog-output-lineout"
fi

# Look up target route index from EnumRoute
TARGET_INDEX=$(pw-dump | jq -r --arg dev "$DEVICE_ID" --arg name "$TARGET_NAME" '
    .[] | select(.id == ($dev | tonumber)) | .info.params.EnumRoute // [] | .[] | select(.name == $name) | .index
')

if [ -z "$TARGET_INDEX" ] || [ "$TARGET_INDEX" = "null" ]; then
    echo "Error: Could not find route '$TARGET_NAME' on device $DEVICE_ID." >&2
    exit 1
fi

# Switch route
pw-cli set-param "$DEVICE_ID" Route "{ \"index\": $TARGET_INDEX, \"device\": $CURRENT_DEVICE, \"save\": true }" >/dev/null

# Verify
NEW_NAME=$(pw-dump | jq -r --arg dev "$DEVICE_ID" '
    .[] | select(.id == ($dev | tonumber)) | .info.params.Route // [] | .[] | select(.direction == "Output") | .description
')

echo "Switched audio output to: $NEW_NAME"

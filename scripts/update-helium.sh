#!/usr/bin/env bash

set -euo pipefail

# Paths
PKG_FILE="./packages/helium.nix"
REPO_OWNER="imputnet"
REPO_NAME="helium-linux"

# Get the latest release version from GitHub API
echo "Checking latest release for ${REPO_OWNER}/${REPO_NAME}..."
latest_version=$(curl -s "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" | jq -r '.tag_name')

if [[ -z "$latest_version" ]]; then
  echo "Error: Could not fetch latest release."
  exit 1
fi

echo "Latest release: $latest_version"

# Get current version in the Nix file
current_version=$(grep -E '^  version = ' "$PKG_FILE" | cut -d'"' -f 2)
echo "Current version in $PKG_FILE: $current_version"

# Compare versions; if latest is same or older, stop
if [[ "$(printf '%s\n' "$latest_version" "$current_version" | sort -V | tail -n 1)" == "$current_version" ]]; then
  echo "Latest version ($latest_version) is not newer than current ($current_version). Nothing to do."
  exit 0
fi

echo "Updating $PKG_FILE from $current_version to $latest_version"

# Calculate the new SRI SHA256 hash using nix-prefetch-url
echo "Calculating new hash..."
appimage_url="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/${latest_version}/helium-${latest_version}-x86_64.AppImage"
hash_nix=$(nix-prefetch-url --type sha256 "$appimage_url" 2>/dev/null | tail -1)
hash_sri=$(nix hash convert --to sri "sha256:$hash_nix" 2>/dev/null)

if [[ -z "$hash_sri" ]]; then
  echo "Error: Failed to compute hash."
  exit 1
fi

echo "New hash: $hash_sri"

# Perform file updates
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS sed
  sed -i '' "s|^  version = \".*\";|  version = \"$latest_version\";|" "$PKG_FILE"
  sed -i '' "s|^    hash = \".*\";|    hash = \"$hash_sri\";|" "$PKG_FILE"
else
  # Linux sed
  sed -i "s|^  version = \".*\";|  version = \"$latest_version\";|" "$PKG_FILE"
  sed -i "s|^    hash = \".*\";|    hash = \"$hash_sri\";|" "$PKG_FILE"
fi

echo "Update complete."
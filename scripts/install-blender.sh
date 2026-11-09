#!/usr/bin/env bash
# Optional: installs Blender for the 3d-artist agent, without admin rights.
# Usage: ./scripts/install-blender.sh [series]   (default series below)
set -euo pipefail

SERIES="${1:-4.5}"
BASE="https://download.blender.org/release/Blender${SERIES}"
INSTALL_ROOT="$HOME/.local/opt"
BIN_DIR="$HOME/.local/bin"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONF="$REPO_DIR/.local/tools.conf"

file="$(curl -fsSL "$BASE/" | grep -oE 'blender-[0-9.]+-linux-x64\.tar\.xz' | sort -Vu | tail -1)"
[ -n "$file" ] || { echo "No Linux build found at $BASE" >&2; exit 1; }
version="${file#blender-}"; version="${version%-linux-x64.tar.xz}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading $file ..."
curl -fL --progress-bar -o "$tmp/$file" "$BASE/$file"

echo "Checking the checksum ..."
curl -fsSL -o "$tmp/sums" "$BASE/blender-$version.sha256"
expected="$(grep "$file" "$tmp/sums" | awk '{print $1}')"
[ -n "$expected" ] || { echo "Checksum for $file not found; stopping." >&2; exit 1; }
echo "$expected  $tmp/$file" | sha256sum -c -

mkdir -p "$INSTALL_ROOT" "$BIN_DIR"
tar -xJf "$tmp/$file" -C "$INSTALL_ROOT"
ln -sfn "$INSTALL_ROOT/${file%.tar.xz}/blender" "$BIN_DIR/blender"

mkdir -p "$(dirname "$CONF")"
touch "$CONF"
grep -q '^blender:' "$CONF" || echo 'blender: on' >> "$CONF"

echo
"$BIN_DIR/blender" -b --version | head -1
echo "Installed. If a shared library is reported missing above, install it with your package manager."

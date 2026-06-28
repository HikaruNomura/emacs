#!/usr/bin/env bash
# install-fonts.sh --- install UDEV Gothic on Linux / WSL2
#
# Downloads the latest UDEV Gothic release from GitHub and installs the
# TTFs into the per-user font directory.  Idempotent: re-running just
# refreshes the files.  No root required.
#
# Usage:  ./scripts/install-fonts.sh
#
# Needs: curl, unzip, fontconfig (fc-cache).  On Debian/Ubuntu:
#   sudo apt-get install -y curl unzip fontconfig

set -euo pipefail

REPO="yuru7/udev-gothic"
DEST="${HOME}/.local/share/fonts/UDEVGothic"
API="https://api.github.com/repos/${REPO}/releases/latest"

for cmd in curl unzip fc-cache; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "error: '$cmd' not found. Install it first (see header)." >&2
        exit 1
    }
done

echo "Looking up the latest UDEV Gothic release..."
# Pick the standard family zip (UDEVGothic_vX...), not NF/HS/LG/35 variants.
url=$(curl -fsSL "$API" \
        | grep -o '"browser_download_url": *"[^"]*"' \
        | sed 's/.*"\(https[^"]*\)"/\1/' \
        | grep -E 'UDEVGothic_v[0-9]' \
        | head -1)

if [ -z "${url:-}" ]; then
    echo "error: could not find a download URL in the latest release." >&2
    exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
zip="${tmp}/udevgothic.zip"

echo "Downloading: $url"
curl -fsSL "$url" -o "$zip"
unzip -q -o "$zip" -d "$tmp"

mkdir -p "$DEST"
find "$tmp" -name '*.ttf' -exec cp -f {} "$DEST/" \;
count=$(find "$DEST" -name '*.ttf' | wc -l)

echo "Refreshing the font cache..."
fc-cache -f "$DEST" >/dev/null

echo "Done. Installed ${count} TTF(s) into ${DEST}."
echo "Check with:  fc-list | grep -i 'UDEV Gothic'"

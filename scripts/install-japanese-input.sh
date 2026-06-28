#!/usr/bin/env bash
# install-japanese-input.sh --- install the Mozc helper for mozc.el
#
# mozc.el needs the `mozc_emacs_helper' binary on PATH.  On Debian/Ubuntu
# (DGX Spark, WSL2) it ships in the emacs-mozc-bin package.  Idempotent.
#
# Usage:  ./scripts/install-japanese-input.sh
#
# Native Windows: there is no easy mozc_emacs_helper; use the Windows IME
# in GUI Emacs there, or just SSH into the Spark/WSL Emacs for Japanese.

set -euo pipefail

if command -v mozc_emacs_helper >/dev/null 2>&1; then
    echo "ok: mozc_emacs_helper already installed at $(command -v mozc_emacs_helper)"
    exit 0
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "error: this helper script targets Debian/Ubuntu (apt-get)." >&2
    echo "Install the Mozc Emacs helper for your distro manually, then re-run." >&2
    exit 1
fi

echo "Installing emacs-mozc-bin (needs sudo)..."
sudo apt-get update
sudo apt-get install -y emacs-mozc-bin

echo "Done: $(command -v mozc_emacs_helper)"
echo "Restart Emacs, then toggle Japanese input with C-\\ (japanese-mozc)."

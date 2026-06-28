#!/usr/bin/env bash
# install-pdf-tools-deps.sh --- build deps for Emacs pdf-tools (epdfinfo)
#
# pdf-tools renders PDFs via a small helper, epdfinfo, that it compiles on
# first use.  This installs what that build needs on Debian/Ubuntu (WSL2,
# Spark).  After running it, open a PDF in Emacs (or M-x pdf-tools-install)
# and the helper builds automatically.  Idempotent.
#
# Usage:  ./scripts/install-pdf-tools-deps.sh
#
# A TeX distribution is separate; install it with your package manager, e.g.
#   sudo apt-get install texlive-latex-recommended texlive-latex-extra \
#        texlive-luatex texlive-lang-japanese latexmk biber
# (or texlive-full for everything).

set -euo pipefail

if command -v epdfinfo >/dev/null 2>&1; then
    echo "ok: epdfinfo already built ($(command -v epdfinfo))"
    exit 0
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "error: targets Debian/Ubuntu (apt-get). Install poppler-glib + png" >&2
    echo "dev headers and a C toolchain for your distro, then M-x pdf-tools-install." >&2
    exit 1
fi

echo "Installing epdfinfo build dependencies (needs sudo)..."
sudo apt-get update
sudo apt-get install -y \
    build-essential automake autoconf pkg-config \
    libpng-dev zlib1g-dev libpoppler-glib-dev libpoppler-private-dev

echo "Done. In Emacs, open a PDF (or run M-x pdf-tools-install) to build epdfinfo."

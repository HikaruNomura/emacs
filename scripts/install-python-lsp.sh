#!/usr/bin/env bash
# install-python-lsp.sh --- install basedpyright for Emacs eglot
#
# init-python.el uses basedpyright for completion / hover / go-to-definition.
# It is NOT a project dependency (so it never touches pyproject.toml); we
# install it as a standalone tool on PATH.  Idempotent.
#
# Tries, in order: uv tool, pipx, npm (global).  On native Windows install
# basedpyright the same way in PowerShell (`uv tool install basedpyright`).
#
# Usage:  ./scripts/install-python-lsp.sh

set -euo pipefail

if command -v basedpyright-langserver >/dev/null 2>&1; then
    echo "ok: basedpyright-langserver already on PATH ($(command -v basedpyright-langserver))"
    exit 0
fi

if command -v uv >/dev/null 2>&1; then
    echo "Installing basedpyright with uv..."
    uv tool install basedpyright
elif command -v pipx >/dev/null 2>&1; then
    echo "Installing basedpyright with pipx..."
    pipx install basedpyright
elif command -v npm >/dev/null 2>&1; then
    echo "Installing basedpyright with npm (global)..."
    npm install -g basedpyright
else
    echo "error: need one of uv, pipx, or npm to install basedpyright." >&2
    exit 1
fi

echo "Done. Ensure the install dir is on PATH, then restart Emacs."
echo "Check with:  basedpyright-langserver --version"

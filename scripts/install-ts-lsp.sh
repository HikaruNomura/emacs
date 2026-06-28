#!/usr/bin/env bash
# install-ts-lsp.sh --- install the TypeScript language server for eglot
#
# init-typescript.el uses eglot's default server, typescript-language-server
# (which drives the official tsserver).  The workspace doesn't ship it, so
# install it globally with npm.  Idempotent.
#
# Usage:  ./scripts/install-ts-lsp.sh
#
# Native Windows: run the same npm command in PowerShell.

set -euo pipefail

if command -v typescript-language-server >/dev/null 2>&1; then
    echo "ok: typescript-language-server already on PATH"
    exit 0
fi

if ! command -v npm >/dev/null 2>&1; then
    echo "error: npm not found. Install Node.js (e.g. via nvm) first." >&2
    exit 1
fi

echo "Installing typescript-language-server + typescript (global)..."
npm install -g typescript-language-server typescript

echo "Done. Restart Emacs; eglot will start it in .ts/.tsx buffers."
echo "Tree-sitter grammars: in Emacs run  M-x my/ts-install-grammars"

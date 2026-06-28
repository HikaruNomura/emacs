#!/usr/bin/env bash
# install.sh --- symlink this repo's Emacs config into ~/.emacs.d
#
# Idempotent: re-running is safe.  Anything already in the way is moved
# into a timestamped backup directory under ~/.emacs.d before linking.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/.emacs.d"
BACKUP_DIR="${DEST}/backup-$(date +%Y%m%d-%H%M%S)"

# Repo entries to link into ~/.emacs.d.
LINKS=(early-init.el init.el lisp)

mkdir -p "$DEST"

link_one() {
    local name="$1"
    local src="${REPO_DIR}/${name}"
    local dst="${DEST}/${name}"

    if [ ! -e "$src" ]; then
        echo "skip: ${name} not found in repo"
        return
    fi

    # Already pointing where we want? Nothing to do.
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
        echo "ok:   ${name} already linked"
        return
    fi

    # Move anything currently occupying the target into the backup dir.
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "${BACKUP_DIR}/"
        echo "back: ${name} -> ${BACKUP_DIR}/"
    fi

    ln -s "$src" "$dst"
    echo "link: ${name} -> ${src}"
}

for name in "${LINKS[@]}"; do
    link_one "$name"
done

echo "Done. Emacs config linked into ${DEST}."

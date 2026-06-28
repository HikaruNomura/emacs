#!/usr/bin/env bash
# sync-eat-terminfo.sh --- install eat's terminfo on a remote host
#
# The in-Emacs `eat' terminal advertises its own TERM (eat-color /
# eat-256color / eat-truecolor).  When you SSH from an eat terminal into a
# server, that server needs eat's terminfo or full-screen apps (tmux, the
# Claude TUI, vim, ...) render incorrectly.  This copies eat's terminfo
# into the remote user's ~/.terminfo.  Run once per server.
#
# Usage:  ./scripts/sync-eat-terminfo.sh user@spark
#         ./scripts/sync-eat-terminfo.sh spark        # ~/.ssh/config alias

set -euo pipefail

REMOTE="${1:-}"
if [ -z "$REMOTE" ]; then
    echo "usage: $0 <ssh-host>   (e.g. user@spark or an ~/.ssh/config alias)" >&2
    exit 1
fi

# Ask Emacs where eat keeps its terminfo, so we don't hardcode the version.
DIR=""
if command -v emacs >/dev/null 2>&1; then
    DIR=$(emacs --batch --eval \
        '(progn (require (quote package)) (package-initialize) (require (quote eat)) (princ eat-term-terminfo-directory))' \
        2>/dev/null || true)
fi
# Fallback: glob the elpa install.
if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
    DIR=$(ls -d "${HOME}"/.emacs.d/elpa/eat-*/terminfo 2>/dev/null | head -1 || true)
fi
if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
    echo "error: could not locate eat's terminfo directory." >&2
    echo "Open Emacs once (so eat is installed) and re-run." >&2
    exit 1
fi

echo "eat terminfo: $DIR"
echo "remote:       ${REMOTE}:~/.terminfo/"

ssh "$REMOTE" 'mkdir -p ~/.terminfo'
if command -v rsync >/dev/null 2>&1; then
    rsync -a "${DIR}/" "${REMOTE}:.terminfo/"
else
    # scp the per-letter subdirs (e/, and the hex 65/ alias dir if present).
    scp -r "${DIR}/." "${REMOTE}:.terminfo/"
fi

echo "Done. Verify on the server with:  ssh ${REMOTE} 'infocmp eat-256color >/dev/null && echo OK'"

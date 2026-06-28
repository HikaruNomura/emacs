# scripts/ — per-environment setup

Helpers for getting Emacs + fonts onto each machine this config targets.
The Elisp config itself (`../init.el`, `../lisp/`) is environment-aware and
needs no changes per machine; these scripts cover the out-of-band bits
(installing the font, building Emacs).

## Fonts (UDEV Gothic)

The config prefers **UDEV Gothic** (ASCII + Japanese) and falls back to
whatever is installed, so installing the font is optional but recommended.

| Environment        | Command |
|--------------------|---------|
| Linux / WSL2 / ARM | `./scripts/install-fonts.sh` |
| Windows (PowerShell) | `powershell -ExecutionPolicy Bypass -File .\scripts\install-fonts.ps1` |

Both install per-user (no admin/root) and are idempotent. Restart Emacs
afterwards. Verify on Linux with `fc-list | grep -i 'UDEV Gothic'`.

## Building / installing Emacs

### Linux / WSL2 / DGX Spark / Pomera DM250
`./scripts/build-emacs.sh` (run with no args first — it prints the build
deps and configure flags to review, then re-run with `--yes`). Builds with
native compilation + tree-sitter. For the low-powered DM250, consider the
distro package or the lighter `--without-x` configure noted in the script.

### Windows
Building native Emacs from source is painful; prefer a prebuilt binary:

- **Scoop**: `scoop install emacs`
- **winget**: `winget install GNU.Emacs`
- Official builds: <https://ftp.gnu.org/gnu/emacs/windows/>
- Or run Emacs inside WSL2 and use the Linux build above.

PowerShell is the default shell on Windows; point Emacs' `shell-file-name`
at it from a future `lisp/init-platform.el` host override if needed.

## After install

Link the config into `~/.emacs.d` (Linux/WSL/macOS):

```sh
./install.sh
```

On native Windows the config dir is `%APPDATA%\.emacs.d` (or
`~/AppData/Roaming/.emacs.d`); symlink or copy `early-init.el`, `init.el`,
and `lisp/` there. A PowerShell installer can be added later if useful.

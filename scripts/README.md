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

## Japanese input (Mozc)

Comfortable Japanese input is the top priority. The config uses `mozc.el`
(Mozc engine, in-Emacs) so it works identically in GUI and in a terminal
over SSH. It needs the `mozc_emacs_helper` binary:

| Environment | Command |
|-------------|---------|
| Debian/Ubuntu (Spark, WSL2) | `./scripts/install-japanese-input.sh` (`apt install emacs-mozc-bin`) |
| Native Windows | no easy helper — use the Windows IME in GUI, or SSH into Spark/WSL |

Toggle input with `C-\` (`japanese-mozc`). If the helper is absent the
config silently skips Mozc, so startup is never broken.

## Python development

Tuned for the nemophila-workspace (uv monorepo: ruff + mypy --strict +
pytest). `pet` auto-detects the project's `.venv` and points ruff / mypy /
pytest / the LSP at it — no paths are hardcoded. Keys in Python buffers:
`C-c y` pytest menu, `C-c m` run strict mypy.

Language server (completion / hover / go-to-definition) is basedpyright,
installed locally (never added to the project's deps):

```sh
./scripts/install-python-lsp.sh        # uv tool / pipx / npm
```

**Per-OS virtualenv.** Development is moving to **Linux/WSL as the primary
target** (Windows is needed only for LabVIEW-FPGA work), so the Linux venv is
the main path: create it on the Linux/WSL side with `uv venv && uv sync` and
`pet` finds `.venv/bin/...` automatically. A **Windows** `.venv` (with
`Scripts\*.exe`) still works from native Windows Emacs, but those `.exe` tools
cannot be used from a WSL/Linux Emacs — each OS needs its own venv with
OS-native binaries inside (pet locates the `.venv` dir either way).

## Building / installing Emacs

### Linux / WSL2 / DGX Spark
`./scripts/build-emacs.sh` (run with no args first — it prints the build
deps and configure flags to review, then re-run with `--yes`). Builds with
native compilation + tree-sitter. The DGX Spark is the main Linux box.

### Pomera DM250
The DM250 runs Emacs **locally in its terminal** (with Japanese input), and
from inside Emacs you open a terminal and `ssh` to the Spark to run tmux +
Claude there (see "Working over SSH" below). So the DM250 needs a local,
terminal-only Emacs — build with the lighter `--without-x` configure, or use
whatever Emacs the device's distro provides.

### Windows
Building native Emacs from source is painful; prefer a prebuilt binary:

- **Scoop**: `scoop install emacs`
- **winget**: `winget install GNU.Emacs`
- Official builds: <https://ftp.gnu.org/gnu/emacs/windows/>
- Or run Emacs inside WSL2 and use the Linux build above.

PowerShell is the default shell on Windows; point Emacs' `shell-file-name`
at it from a future `lisp/init-platform.el` host override if needed.

## Working over SSH (eat + tmux + Claude on a server)

Two ways to use Claude from Emacs, both supported:

- **Local** — `M-x claude-code` (`C-c c`) runs the `claude` CLI as a local
  subprocess. Use when Emacs runs on the same box you want Claude on.
- **Remote** — open an in-Emacs terminal and SSH to a server, then run tmux
  + `claude` there. Use from the DM250 (Emacs local) into the Spark.

Terminal keys (prefix `C-c t`): `t` here, `o` other window, `p` project,
`s` SSH to a host. Populate the host list once:

```elisp
(setq my/ssh-hosts '("spark" "user@dgx"))   ; ~/.ssh/config aliases are fine
```

**One-time per server:** the `eat` terminal uses its own `TERM`, so install
eat's terminfo on the server or tmux/Claude's TUI will render wrong:

```sh
./scripts/sync-eat-terminfo.sh spark
```

## After install

Link the config into `~/.emacs.d` (Linux/WSL/macOS):

```sh
./install.sh
```

On native Windows the config dir is `%APPDATA%\.emacs.d` (or
`~/AppData/Roaming/.emacs.d`); symlink or copy `early-init.el`, `init.el`,
and `lisp/` there. A PowerShell installer can be added later if useful.

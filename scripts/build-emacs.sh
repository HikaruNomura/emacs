#!/usr/bin/env bash
# build-emacs.sh --- build Emacs from source on Linux / WSL2 / ARM
#
# A reference build for the GNU/Linux machines (WSL2, DGX Spark ARM64,
# Pomera DM250 ARM).  It builds with native compilation and tree-sitter,
# which suit the powerful boxes; on the very small DM250 you may prefer a
# lighter configure (see NOTES) or the distro package instead.
#
# This script is intentionally explicit -- READ IT before running and
# adjust VERSION / flags for the machine.  Run with --yes to proceed.
#
# Usage:
#   ./scripts/build-emacs.sh --yes            # build + install to PREFIX
#   EMACS_VERSION=30.2 PREFIX=$HOME/.local ./scripts/build-emacs.sh --yes

set -euo pipefail

EMACS_VERSION="${EMACS_VERSION:-30.2}"
PREFIX="${PREFIX:-/usr/local}"
JOBS="${JOBS:-$(nproc 2>/dev/null || echo 2)}"

if [ "${1:-}" != "--yes" ]; then
    cat <<EOF
This will download and build Emacs ${EMACS_VERSION} and install into ${PREFIX}.
Review the apt dependencies and configure flags below first, then re-run:

    ./scripts/build-emacs.sh --yes

NOTES
  * Debian/Ubuntu build deps (run once, needs sudo):
      sudo apt-get update
      sudo apt-get build-dep emacs      # if deb-src is enabled, easiest
      # ...or install the common set explicitly:
      sudo apt-get install -y build-essential texinfo libgccjit-12-dev \\
        gcc-12 libgnutls28-dev libtree-sitter-dev libjansson-dev \\
        libncurses-dev libgtk-3-dev libxpm-dev libjpeg-dev libpng-dev \\
        libgif-dev libtiff-dev libgnutls28-dev

  * GUI vs terminal: the flags below build GUI support (--with-x).  For a
    headless / terminal-only box (e.g. the DM250) you can swap in
    --without-x --with-tree-sitter and drop the GTK deps for a smaller,
    faster build.

  * ARM (DGX Spark, DM250): native compilation (libgccjit) works on arm64;
    just ensure the matching gcc-NN / libgccjit-NN-dev versions are present.
EOF
    exit 0
fi

src="${HOME}/src"
mkdir -p "$src"
cd "$src"

tarball="emacs-${EMACS_VERSION}.tar.xz"
url="https://ftpmirror.gnu.org/emacs/${tarball}"

if [ ! -f "$tarball" ]; then
    echo "Downloading ${url}"
    curl -fSL "$url" -o "$tarball"
fi

rm -rf "emacs-${EMACS_VERSION}"
tar xf "$tarball"
cd "emacs-${EMACS_VERSION}"

echo "Configuring (prefix=${PREFIX})..."
./configure \
    --prefix="${PREFIX}" \
    --with-native-compilation=aot \
    --with-tree-sitter \
    --with-json \
    --with-x \
    --with-modules

echo "Building with ${JOBS} jobs..."
make -j"${JOBS}"

echo "Installing into ${PREFIX} (may need sudo if not writable)..."
if [ -w "${PREFIX}" ]; then
    make install
else
    sudo make install
fi

echo "Done. $(command -v emacs) -> $(emacs --version | head -1)"

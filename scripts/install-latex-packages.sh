#!/bin/bash
# ===================================================================
# Overleaf Toolkit – Smart LaTeX Package Installer
# Author: Md. Fahim Bin Amin
# ===================================================================
set -uo pipefail

# Load environment variables
source "$(dirname "${BASH_SOURCE[0]}")/load-env.sh"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting LaTeX package check"

require_container

echo "Updating tlmgr (TeX Live Manager)..."
if docker exec "$CONTAINER_NAME" tlmgr update --self; then
  echo "tlmgr updated."
else
  echo "Warning: 'tlmgr update --self' failed; continuing with the existing tlmgr." >&2
fi

# Package list. Names are *tlmgr package* names, which can differ from the
# LaTeX package you \usepackage{}:
#   graphics -> graphicx        tools   -> array, longtable, tabularx
#   algorithms -> algorithm, algorithmic      pgf -> tikz
#   amsfonts -> amssymb         caption -> subcaption
ALL_PACKAGES=(
  amsmath amsfonts mathtools siunitx
  xcolor graphics float geometry fancyhdr subfig caption
  listings algorithms algorithm2e
  pgf pgfplots
  hyperref booktabs multirow tools lipsum
)

FAILED=()

echo "Checking LaTeX packages inside '${CONTAINER_NAME}'..."
for pkg in "${ALL_PACKAGES[@]}"; do
  if docker exec "$CONTAINER_NAME" tlmgr info "$pkg" 2>/dev/null | grep -q "installed: *Yes"; then
    echo "$pkg already installed."
  else
    echo "Installing $pkg ..."
    if docker exec "$CONTAINER_NAME" tlmgr install "$pkg"; then
      echo "$pkg installed successfully."
    else
      echo "Failed to install $pkg." >&2
      FAILED+=("$pkg")
    fi
  fi
done

if [ ${#FAILED[@]} -gt 0 ]; then
  echo "Finished with errors. Failed packages: ${FAILED[*]}" >&2
  exit 1
fi

echo "All LaTeX packages are installed."

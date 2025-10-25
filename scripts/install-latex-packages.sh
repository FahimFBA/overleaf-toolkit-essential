#!/bin/bash
# ===================================================================
# Overleaf Toolkit – Smart LaTeX Package Installer
# Author: Md. Fahim Bin Amin
# ===================================================================

# Load environment variables
source "$(dirname "$0")/load-env.sh"

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container '${CONTAINER_NAME}' is not running."
  echo "Start it first with: docker start ${CONTAINER_NAME}"
  exit 1
fi

echo "Updating tlmgr (TeX Live Manager)..."
docker exec -i $CONTAINER_NAME tlmgr update --self >/dev/null 2>&1
echo "tlmgr updated."

# Package list
ALL_PACKAGES=(
  amsmath amsfonts amssymb mathtools siunitx
  xcolor graphicx float geometry fancyhdr subfig caption subcaption
  listings algorithm algorithmic algorithms algorithm2e
  tikz pgfplots
  hyperref booktabs multirow array longtable tabularx lipsum
)

# Install missing packages
echo "Checking LaTeX packages inside '${CONTAINER_NAME}'..."
for pkg in "${ALL_PACKAGES[@]}"; do
  docker exec -i $CONTAINER_NAME tlmgr info "$pkg" 2>/dev/null | grep -q "installed: Yes"
  if [ $? -eq 0 ]; then
    echo "$pkg already installed."
  else
    echo "Installing $pkg ..."
    docker exec -i $CONTAINER_NAME tlmgr install "$pkg" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "$pkg installed successfully."
    else
      echo "Failed to install $pkg."
    fi
  fi
done

echo "All LaTeX packages are now up to date."

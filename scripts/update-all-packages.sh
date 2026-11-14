#!/bin/bash
# ===================================================================
# Overleaf Toolkit – Full LaTeX Update Script
# Author: Md. Fahim Bin Amin
# ===================================================================
set -uo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/load-env.sh"

require_container

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Updating tlmgr and all TeX Live packages inside '${CONTAINER_NAME}'..."

if docker exec "$CONTAINER_NAME" tlmgr update --self --all; then
  echo "All LaTeX packages successfully updated."
else
  echo "Error: Some packages could not be updated." >&2
  exit 1
fi

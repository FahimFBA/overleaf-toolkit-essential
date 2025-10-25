#!/bin/bash
# ===================================================================
# Overleaf Toolkit – Full LaTeX Update Script
# Author: Md. Fahim Bin Amin
# ===================================================================

source "$(dirname "$0")/load-env.sh"

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container '${CONTAINER_NAME}' is not running."
  echo "Start it first with: docker start ${CONTAINER_NAME}"
  exit 1
fi

echo "Updating tlmgr and all TeX Live packages inside '${CONTAINER_NAME}'..."
docker exec -i $CONTAINER_NAME tlmgr update --self --all >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "All LaTeX packages successfully updated."
else
  echo "Error: Some packages could not be updated."
fi

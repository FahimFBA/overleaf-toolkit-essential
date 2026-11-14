#!/bin/bash
# ===================================================================
# Overleaf Toolkit – Weekly Auto-Update Cron Setup
# Author: Md. Fahim Bin Amin
# ===================================================================
set -uo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/load-env.sh"

if [ ! -f "$INSTALL_SCRIPT" ]; then
  echo "Cannot find $INSTALL_SCRIPT" >&2
  echo "Please check your .env configuration." >&2
  exit 1
fi

echo "Setting up cron job with schedule: ${CRON_EXPR}"

# Keep all existing cron entries, replacing only ours.
# ('|| true' because grep -v exits 1 when the crontab is empty.)
EXISTING="$(crontab -l 2>/dev/null | grep -vF "$INSTALL_SCRIPT" || true)"

{
  [ -n "$EXISTING" ] && printf '%s\n' "$EXISTING"
  echo "${CRON_EXPR} ${INSTALL_SCRIPT} >> ${LOG_FILE} 2>&1"
} | crontab -

echo "Cron job installed successfully."
echo "Schedule : ${CRON_EXPR}"
echo "Log file : ${LOG_FILE}"

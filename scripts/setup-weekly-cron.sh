#!/bin/bash
# ===================================================================
# Overleaf Toolkit – Weekly Auto-Update Cron Setup
# Author: Md. Fahim Bin Amin
# ===================================================================

source "$(dirname "$0")/load-env.sh"

if [ ! -f "$INSTALL_SCRIPT" ]; then
  echo "Cannot find $INSTALL_SCRIPT"
  echo "Please check your .env configuration."
  exit 1
fi

echo "Setting up weekly cron job to run every Monday at 4:00 AM..."

# Remove old cron job if exists
(crontab -l 2>/dev/null | grep -v "$INSTALL_SCRIPT") | crontab -

# Add new cron job
echo "0 4 * * 1 $INSTALL_SCRIPT >> $LOG_FILE 2>&1" | crontab -

echo "Cron job installed successfully."
echo "It will run every Monday at 4 AM and log output to:"
echo "$LOG_FILE"

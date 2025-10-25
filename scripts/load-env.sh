#!/bin/bash
# ==========================================================
# Loads environment variables from the project .env file
# ==========================================================

# Default .env location (in repo root)
ENV_FILE="$(dirname "$0")/../.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "Error: .env file not found at $ENV_FILE"
  echo "Please create one using the provided template."
  exit 1
fi

# Export all variables
export $(grep -v '^#' "$ENV_FILE" | xargs)

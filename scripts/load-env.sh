#!/bin/bash
# ==========================================================
# Loads environment variables from the project .env file.
# Meant to be sourced by the other scripts.
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/../.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "Error: .env file not found at $ENV_FILE" >&2
  echo "Please create one using the provided template (cp .env.example .env)." >&2
  exit 1
fi

# Source (not xargs) so $HOME / $PROJECT_DIR references are expanded
# and values containing spaces work. 'set -a' exports everything.
set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

# Fallback defaults for values that are safe to guess
CONTAINER_NAME="${CONTAINER_NAME:-sharelatex}"
PROJECT_DIR="${PROJECT_DIR:-$(cd "${SCRIPT_DIR}/.." && pwd)}"
LOG_FILE="${LOG_FILE:-${PROJECT_DIR}/latex-update.log}"
INSTALL_SCRIPT="${INSTALL_SCRIPT:-${PROJECT_DIR}/scripts/install-latex-packages.sh}"
CRON_EXPR="${CRON_EXPR:-0 4 * * 1}"

# Exit with a helpful message unless the Overleaf container is running.
require_container() {
  if ! docker ps --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}"; then
    echo "Container '${CONTAINER_NAME}' is not running." >&2
    echo "Start it first with: docker start ${CONTAINER_NAME}" >&2
    exit 1
  fi
}

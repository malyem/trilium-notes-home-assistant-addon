#!/bin/bash
# Entrypoint wrapper for the Trilium Notes Home Assistant add-on.
#
# Reads the add-on options (set via the Home Assistant UI and persisted by
# the Supervisor to /data/options.json) and exports them as the environment
# variables expected by the upstream Trilium docker image, then hands off
# execution to the original image entrypoint/cmd unchanged.
set -e

OPTIONS_FILE=/data/options.json

# Default IDs matching the upstream Trilium image.
USER_UID="${USER_UID:-1000}"
USER_GID="${USER_GID:-1000}"

if [ -f "${OPTIONS_FILE}" ]; then
  USER_UID_OPT=$(jq -r '.user_uid // empty' "${OPTIONS_FILE}")
  USER_GID_OPT=$(jq -r '.user_gid // empty' "${OPTIONS_FILE}")

  [ -n "${USER_UID_OPT}" ] && USER_UID="${USER_UID_OPT}"
  [ -n "${USER_GID_OPT}" ] && USER_GID="${USER_GID_OPT}"
fi

# Refuse to run as root inside the container. The upstream image intentionally
# drops privileges to the 'node' user; running as root would break that model
# and is unnecessary for a note-taking application.
if [ "${USER_UID}" -eq 0 ] || [ "${USER_GID}" -eq 0 ]; then
  echo "[trilium-notes] ERROR: user_uid and user_gid must be non-zero." >&2
  exit 1
fi

export USER_UID USER_GID

DATA_DIR=/data/trilium-data
TRILIUM_DATA_DIR=/home/node/trilium-data
mkdir -p "${DATA_DIR}"

# The upstream start-docker.sh only chowns /home/node, so make sure our
# custom data directory (which lives under the add-on's /data, outside of
# /home/node) is also owned by the target user/group before Trilium starts.
# To avoid a slow recursive chown on every start, only fix ownership when the
# top-level directory is not already owned by the target user/group.
if [ "$(stat -c '%u:%g' "${DATA_DIR}")" != "${USER_UID}:${USER_GID}" ]; then
  chown -R "${USER_UID}:${USER_GID}" "${DATA_DIR}"
fi

if [ -e "${TRILIUM_DATA_DIR}" ] && [ ! -L "${TRILIUM_DATA_DIR}" ]; then
  rm -rf "${TRILIUM_DATA_DIR}"
fi
ln -sfn "${DATA_DIR}" "${TRILIUM_DATA_DIR}"

echo "[trilium-notes] Starting Trilium Notes (data dir: ${DATA_DIR}, USER_UID=${USER_UID}, USER_GID=${USER_GID})"

# Hand off to the upstream image's own entrypoint / start script.
exec /usr/local/bin/docker-entrypoint.sh sh ./start-docker.sh

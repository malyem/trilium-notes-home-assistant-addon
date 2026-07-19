#!/bin/bash
# Entrypoint wrapper for the Trilium Notes Home Assistant add-on.
#
# Reads the add-on options (set via the Home Assistant UI and persisted by
# the Supervisor to /data/options.json) and exports them as the environment
# variables expected by the upstream Trilium docker image, then hands off
# execution to the original image entrypoint/cmd unchanged.
set -e

OPTIONS_FILE=/data/options.json

if [ -f "${OPTIONS_FILE}" ]; then
  USER_UID_OPT=$(jq -r '.user_uid // empty' "${OPTIONS_FILE}")
  USER_GID_OPT=$(jq -r '.user_gid // empty' "${OPTIONS_FILE}")

  [ -n "${USER_UID_OPT}" ] && export USER_UID="${USER_UID_OPT}"
  [ -n "${USER_GID_OPT}" ] && export USER_GID="${USER_GID_OPT}"
fi

DATA_DIR="${TRILIUM_DATA_DIR:-/data/trilium-data}"
mkdir -p "${DATA_DIR}"

# The upstream start-docker.sh only chowns /home/node, so make sure our
# custom data directory (which lives under the add-on's /data, outside of
# /home/node) is also owned by the target user/group before Trilium starts.
chown -R "${USER_UID:-1000}:${USER_GID:-1000}" "${DATA_DIR}"

echo "[trilium-notes] Starting Trilium Notes (data dir: ${TRILIUM_DATA_DIR}, USER_UID=${USER_UID:-1000}, USER_GID=${USER_GID:-1000})"

# Hand off to the upstream image's own entrypoint / start script.
exec docker-entrypoint.sh sh ./start-docker.sh

# This add-on wraps the official TriliumNext/Trilium Docker image so it can be
# installed and managed through the Home Assistant Supervisor.
#
# Upstream installation reference:
# https://docs.triliumnotes.org/user-guide/setup/server/installation/docker
ARG TRILIUM_VERSION=v0.104.0
ARG BUILD_VERSION=1.0.0
ARG BUILD_ARCH=amd64
FROM triliumnext/trilium:${TRILIUM_VERSION}

ARG BUILD_VERSION
ARG BUILD_ARCH

# jq is used by run.sh to read the add-on options set from the Home Assistant UI
# (stored by the Supervisor in /data/options.json). Upstream uses Alpine for
# amd64 and Debian for the other architectures.
RUN set -eux; \
    if command -v apk >/dev/null 2>&1; then \
        apk add --no-cache jq; \
    elif command -v apt-get >/dev/null 2>&1; then \
        apt-get update; \
        apt-get install -y --no-install-recommends jq; \
        rm -rf /var/lib/apt/lists/*; \
    else \
        echo "Unsupported base image: no supported package manager found" >&2; \
        exit 1; \
    fi

COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Labels help the Home Assistant Supervisor identify the add-on image when it is
# not built through the official GitHub builder actions.
LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="app" \
  io.hass.arch="${BUILD_ARCH}"

# The upstream image already runs "docker-entrypoint.sh sh ./start-docker.sh"
# as its own ENTRYPOINT/CMD (see start-docker.sh, which handles USER_UID/
# USER_GID and drops privileges to the "node" user). We only need to inject
# the values coming from the Home Assistant add-on options before handing
# off control to that original process.
ENTRYPOINT ["/run.sh"]

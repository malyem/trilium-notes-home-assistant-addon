# This add-on wraps the official TriliumNext/Trilium Docker image so it can be
# installed and managed through the Home Assistant Supervisor.
#
# Upstream installation reference:
# https://docs.triliumnotes.org/user-guide/setup/server/installation/docker
ARG TRILIUM_VERSION=v0.103.0
ARG BUILD_VERSION=1.0.0
ARG BUILD_ARCH=amd64
FROM triliumnext/trilium:${TRILIUM_VERSION}

ARG BUILD_VERSION
ARG BUILD_ARCH

# jq is used by run.sh to read the add-on options set from the Home Assistant UI
# (stored by the Supervisor in /data/options.json).
# The upstream image is Alpine-based, so use apk instead of apt-get.
RUN apk add --no-cache jq

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

# This add-on wraps the official TriliumNext/Trilium Docker image so it can be
# installed and managed through the Home Assistant Supervisor.
#
# Upstream installation reference:
# https://docs.triliumnotes.org/user-guide/setup/server/installation/docker
ARG TRILIUM_VERSION=v0.103.0
FROM triliumnext/trilium:${TRILIUM_VERSION}

# jq is used by run.sh to read the add-on options set from the Home Assistant UI
# (stored by the Supervisor in /data/options.json).
RUN apt-get update \
    && apt-get install -y --no-install-recommends jq \
    && rm -rf /var/lib/apt/lists/*

# Store the Trilium document/data files inside the add-on's persistent /data
# folder, which the Supervisor keeps across restarts and add-on updates.
ENV TRILIUM_DATA_DIR=/data/trilium-data

COPY run.sh /run.sh
RUN chmod a+x /run.sh

# The upstream image already runs "docker-entrypoint.sh sh ./start-docker.sh"
# as its own ENTRYPOINT/CMD (see start-docker.sh, which handles USER_UID/
# USER_GID and drops privileges to the "node" user). We only need to inject
# the values coming from the Home Assistant add-on options before handing
# off control to that original process.
ENTRYPOINT ["/run.sh"]

# Trilium Notes — Home Assistant Add-on

Home Assistant Supervisor add-on for [Trilium Notes](https://github.com/TriliumNext/Trilium), a
hierarchical, self-hosted note taking application.

This add-on packages the official `triliumnext/trilium` Docker image
(see the [upstream Docker installation guide](https://docs.triliumnotes.org/user-guide/setup/server/installation/docker))
so it runs and updates through Home Assistant's Supervisor like any other add-on.

## Installation

1. Copy this folder into your Home Assistant `addons` (local add-ons) directory, e.g.
   `/addons/trilium-notes-home-assistant-addon`.
2. In Home Assistant, go to **Settings → Add-ons → Add-on Store**, click the
   **⋮** menu → **Check for updates**/**Repositories** (or just refresh the page)
   so the local add-on is picked up.
3. Find **Trilium Notes** under "Local add-ons", click **Install**.
4. Start the add-on and open the Web UI (port `8080` by default).

## Configuration

| Option     | Default | Description                                                        |
|------------|---------|----------------------------------------------------------------------|
| `user_uid` | `1000`  | Linux UID used to own the Trilium data files (matches upstream `USER_UID`). |
| `user_gid` | `1000`  | Linux GID used to own the Trilium data files (matches upstream `USER_GID`). |

The web interface port (`8080` by default) can be changed from the add-on's
**Network** configuration tab.

## Data storage

Trilium's document database is stored inside the add-on's persistent
`/data/trilium-data` folder, which Home Assistant keeps across add-on restarts
and updates (backed up together with your other add-on data).

## Updating the Trilium version

The Dockerfile pins a specific upstream version via the `TRILIUM_VERSION` build
argument (see `Dockerfile`), following the upstream recommendation to avoid the
`latest` tag. Bump `TRILIUM_VERSION` and `version` in `config.yaml` together
when upgrading, then rebuild the add-on.

See [DOCS.md](DOCS.md) for more detailed usage notes.

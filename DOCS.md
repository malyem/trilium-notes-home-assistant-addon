# Home Assistant Add-on: Trilium Notes

## About

[Trilium Notes](https://github.com/TriliumNext/Trilium) is a self-hosted,
hierarchical note-taking application with note versioning, encryption,
attributes, relation maps and more. This add-on runs the official
`triliumnext/trilium` Docker image under the Home Assistant Supervisor,
following the steps from the
[upstream Docker installation guide](https://docs.triliumnotes.org/user-guide/setup/server/installation/docker).

## How it works

* `Dockerfile` builds `FROM triliumnext/trilium:<TRILIUM_VERSION>` and adds
  `jq`, used only to read the add-on's options file.
* `run.sh` replaces the image's default `ENTRYPOINT`. It reads
  `/data/options.json` (written by the Supervisor from your add-on
  configuration), exports `USER_UID`/`USER_GID` accordingly, ensures the data
  directory exists, and then executes the *original* upstream entrypoint
  (`docker-entrypoint.sh sh ./start-docker.sh`) unmodified — the same
  `USER_UID`/`USER_GID`/data-dir handling documented upstream still applies.
* `TRILIUM_DATA_DIR` is set to `/data/trilium-data`, so notes live inside the
  add-on's persistent `/data` folder that Home Assistant automatically
  provisions and backs up per add-on.

## Installation

1. Copy the whole `trilium-notes-home-assistant-addon` folder into your Home
   Assistant `addons` local add-ons folder (create it under
   `/addons/local` if it does not exist yet, or add this repository via
   **Settings → Add-ons → Add-on Store → Repositories**).
2. Refresh the Add-on Store; **Trilium Notes** appears under "Local add-ons".
3. Click **Install**, wait for the image to build, then **Start** the add-on.
4. Open the add-on's **Web UI** (or browse to
   `http://<home-assistant-ip>:8080`) to finish the initial Trilium setup
   (setting your login password on first run).

## Configuration options

```yaml
user_uid: 1000
user_gid: 1000
```

### Option: `user_uid`

Linux user ID that will own the files under `/data/trilium-data` inside the
container. Change this if you want the files on your Home Assistant host to
be owned by a specific UID.

### Option: `user_gid`

Linux group ID that will own the files under `/data/trilium-data` inside the
container.

## Networking

The add-on exposes port `8080/tcp` by default (Trilium's web interface). You
can remap the host port from the add-on's **Network** tab, exactly as you
would with `-p <host-port>:8080` when running the upstream container
manually.

## Reverse proxy

If you want to expose Trilium through a reverse proxy add-on (e.g. Nginx
Proxy Manager) instead of directly on a port, point the proxy at
`http://<home-assistant-ip>:8080` (or the internal add-on hostname) as
described in the
[upstream reverse proxy docs](https://docs.triliumnotes.org/user-guide/setup/server/reverse-proxy/nginx).

## Backups

Because Trilium's data lives under the add-on's persistent `/data` folder,
it is included automatically whenever you create a Home Assistant full or
partial (add-on) backup/snapshot.

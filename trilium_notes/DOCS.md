# Home Assistant Add-on: Trilium Notes

Run [Trilium Notes](https://github.com/TriliumNext/Trilium) as a Home Assistant
add-on. Trilium is a self-hosted application for organizing notes in a
hierarchy.

## First start

1. Install and start the add-on from the Add-on Store.
2. Select **Open Web UI** on the add-on page.
3. Set a password in Trilium, then sign in.

## Configuration

`user_uid` and `user_gid` control ownership of Trilium data files. Leave both
at `1000` unless you need the files to belong to a specific Linux user or group.
Neither value may be `0`.

## Networking

Trilium listens on port `8080` inside the add-on and is exposed on port `8087`
by default. Change the published host port from the add-on's **Network** tab if
needed.

## Reverse proxy

To expose Trilium through a reverse proxy, point it at
`http://<home-assistant-ip>:8087` or at the host port you configured. Follow
the [Trilium reverse proxy guide](https://docs.triliumnotes.org/user-guide/setup/server/reverse-proxy/nginx)
for the upstream application settings.

## Data and backups

Trilium stores its data in the add-on's persistent data directory. It is kept
across restarts and updates, and is included in Home Assistant add-on and full
backups. Create a backup before updating the add-on or making major changes to
your notes.

## Troubleshooting

If the add-on does not start, review its **Log** tab in Home Assistant. For
sign-in, synchronization, or note-management issues, consult the
[official Trilium documentation](https://docs.triliumnotes.org/).

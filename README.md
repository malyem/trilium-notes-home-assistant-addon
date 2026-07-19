# Trilium Notes — Home Assistant Add-on

Run [Trilium Notes](https://github.com/TriliumNext/Trilium), a self-hosted,
hierarchical note-taking application, from your Home Assistant instance.

[![Add this add-on repository to your Home Assistant instance](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository=https%3A%2F%2Fgithub.com%2Fmalyem%2Ftrilium-notes-home-assistant-addon)

## Installation

1. Click the **Add this add-on repository** button above and confirm in Home
   Assistant.
2. Alternatively, in Home Assistant open **Settings → Add-ons → Add-on Store**,
   select **⋮ → Repositories**, and add:

   ```text
   https://github.com/malyem/trilium-notes-home-assistant-addon
   ```

3. Refresh the Add-on Store, find **Trilium Notes**, and select **Install**.
4. Start the add-on and open the Web UI (port `8087` by default).

## First start

Open **Web UI** from the add-on page and set a Trilium password. After that,
sign in using the same address whenever you want to access your notes.

## Configuration

| Option     | Default | Description                                                                 |
|------------|---------|-----------------------------------------------------------------------------|
| `user_uid` | `1000`  | Linux UID used to own the Trilium data files (matches upstream `USER_UID`). |
| `user_gid` | `1000`  | Linux GID used to own the Trilium data files (matches upstream `USER_GID`). |

The default values work for most installations. Change them only when the
Trilium data directory must be owned by a specific Linux user or group.

See [the add-on documentation](trilium_notes/DOCS.md) for networking, backups,
and troubleshooting.

# Changelog

## 1.0.2

- Add GitHub Actions workflows that detect stable Trilium releases, open an
  update pull request, and build the add-on image for every supported
  architecture.
- Change the default host port to `8087`.

## 1.0.1

- Store Trilium data persistently by linking its expected data directory to the
  add-on's `/data/trilium-data` directory.
- Align the AppArmor profile with the upstream image's actual startup paths.

## 1.0.0

- Separated add-on version from the upstream Trilium version.
- Added `webui` so the Trilium interface opens directly from the add-on page.
- Added `io.hass.*` labels to the Docker image.
- Hardened `run.sh`: non-zero UID/GID validation and conditional `chown`.
- Added a custom AppArmor profile (`apparmor.txt`).
- Added `icon.png` and `logo.png` for the Add-on Store.
- Removed deprecated `hassio_api` / `homeassistant_api` config options.

## 0.103.0

- Initial release of the Trilium Notes Home Assistant add-on, based on
  `triliumnext/trilium:v0.103.0`.

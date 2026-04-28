# inputs.nix

Central dependency flake for dotfiles.nix.

This flake aggregates commonly used inputs and modules for NixOS and Home Manager configurations to centralize dependency management and updates.

## Provided Modules

### `nixosModules.default`
Imports NixOS modules from:
- `disko`
- `sops-nix`
- `home-manager`
- `nix-flatpak`
- `gog-nix`

### `homeModules.default`
Imports Home Manager modules from:
- `sops-nix`
- `caelestia-shell`
- `nixvim`
- `stylix`

## Development

This flake provides a development shell with necessary tools for managing the repository.

### Development Shell
To enter the development environment, run:
```bash
nix develop
```
The shell includes:
- `just`: A handy command runner for common tasks.

### Just Recipes
Available commands within the development shell (or via `nix develop --command just ...`):
- `just update`: Pulls latest changes, updates the flake lockfile, and runs `gmc --auto`.

## Automated Updates
This repository includes a GitHub workflow to automatically update `flake.lock` dependencies.

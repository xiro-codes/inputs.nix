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

## Automated Updates
This repository includes a GitHub workflow to automatically update `flake.lock` dependencies.

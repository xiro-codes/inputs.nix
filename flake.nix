{
  description = "Central dependecy flake for dotfiles.nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nvim-nix.url = "github:xiro-codes/nvim.nix";
    harmonia.url = "github:nix-community/harmonia";
    caelestia-live.url = "github:xiro-codes/caelestia-live/v0.1.0_final";
    fuchsia-nix = {
      url = "github:xiro-codes/fuchsia.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentsddm = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gog-nix = {
      url = "github:xiro-codes/gog.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
    nix-topology.url = "github:oddlama/nix-topology";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    impermanence.url = "github:nix-community/impermanence";
    nix-compose = {
      url = "github:xiro-codes/nix-compose";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = {
        inherit inputs;
        schemaBuilder = import ./schemas.nix;
        nixosModules.default = {
          imports = [
            inputs.disko.nixosModules.disko
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.gog-nix.nixosModules.gog
            inputs.rocket-blog.nixosModules.default
            inputs.silentsddm.nixosModules.default
            inputs.harmonia.nixosModules.harmonia
            inputs.impermanence.nixosModules.impermanence
            inputs.determinate.nixosModules.default
            inputs.nix-topology.nixosModules.default
            inputs.nix-compose.nixosModules.daemon
          ];
        };
        homeModules.default = {
          imports = [
            inputs.fuchsia-nix.homeModules.default
            inputs.sops-nix.homeModules.sops
            inputs.caelestia-shell.homeManagerModules.default
            inputs.nixvim.homeModules.nixvim
            inputs.stylix.homeModules.stylix
          ];
        };
      };

      perSystem =
        { pkgs, system, ... }:
        {
          formatter = pkgs.nixfmt;
          packages = 
            inputs.nvim-nix.packages.${system} // 
            { caelestia-live = inputs.caelestia-live.packages.${system}.default;};
          devShells.default = pkgs.mkShell {
            packages = [ pkgs.just ];
          };

        };
    };
}

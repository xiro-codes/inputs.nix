{
  description = "Central dependecy flake for dotfiles.nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    rocket-blog.url = "github:xiro-codes/rocket_blog";
    nvim-nix.url = "github:xiro-codes/nvim.nix";
    harmonia.url = "github:nix-community/harmonia";
    silentsddm = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/master";
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
      url = "github:caelestia-dots/shell/v1.5.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
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
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = {
        inherit inputs;
        discovery = import ./discovery;
        schemaBuilder = import ./schemas.nix;
        nixosModules.default = {
          imports = [
            ./modules/system/bootloader
            ./modules/system/disks
            ./modules/system/network
            ./modules/system/nix-core-settings
            ./modules/system/secrets
            ./modules/system/security
            ./modules/system/user-manager
            ./modules/system/localization
            inputs.disko.nixosModules.disko
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.gog-nix.nixosModules.gog
            inputs.rocket-blog.nixosModules.default
            inputs.silentsddm.nixosModules.default
            inputs.harmonia.nixosModules.harmonia
          ];
        };
        homeModules.default = {
          imports = [
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
          packages = inputs.nvim-nix.packages.${system};
          devShells.default = pkgs.mkShell {
            packages = [ pkgs.just ];
          };

        };
    };
}

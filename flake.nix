{
  description = "Central dependecy flake for dotfiles.nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    stylix = {
      url = "github:danth/stylix/release-25.11";
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
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@ { self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = {
        inherit inputs;
        nixosModules.default = {
          imports = [
            inputs.disko.nixosModules.disko
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.gog-nix.nixosModules.gog
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
    };
}

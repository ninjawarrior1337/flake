{
  description = "Treelar's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, ... }@inputs: 
  let 
    user = "ninjawarrior1337";
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in rec {
    nixosConfigurations.treeputer = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs user system;};
      modules = [
        ./configurations/treeputer/configuration.nix
        ./home/base.nix
        # ./lanzaboote.nix
        
        inputs.vscode-server.nixosModules.default
        home-manager.nixosModules.home-manager
        # inputs.lanzaboote.nixosModules.lanzaboote

        ({ config, pkgs, ... }: {
          services.vscode-server.enable = true;
        })
        { nixpkgs.config.allowUnfree = true; }
      ];
    };

    nixosConfigurations.thisismycomputernow = nixpkgs-unstable.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs system; user = "nixos"; };
      modules = [
        "${nixpkgs-unstable}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
        ./configurations/thisismycomputernow
        ./home/base.nix
        inputs.home-manager-unstable.nixosModules.home-manager
        { nixpkgs.config.allowUnfree = true; }
      ];
    };

    nixosConfigurations.rpi3 = nixpkgs-unstable.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit inputs user;};
      modules = [
        "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ./configurations/rpi3
        ./home/base.nix

        home-manager-unstable.nixosModules.home-manager
        ({lib, ...}: {boot.supportedFilesystems = lib.mkForce [ "ext4" "vfat" ];})
      ];
    };

    images.rpi3 = nixosConfigurations.rpi3.config.system.build.sdImage;
    images.thisismycomputernow = nixosConfigurations.thisismycomputernow.config.system.build.isoImage;

    packages."aarch64-linux" = {
      fm_transmitter = pkgs.callPackage ./packages/fm_transmitter {};
    };
  };
}

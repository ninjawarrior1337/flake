{
  description = "Treelar's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, ... }@inputs: 
  let 
    user = "ninjawarrior1337";
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
  in rec {
    nixosConfigurations.treeputer = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs user;};
      modules = [
        ./configurations/treeputer/configuration.nix
        ./home-manager.nix
        
        home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays = [overlay-unstable];
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };

    nixosConfigurations.rpi3 = nixpkgs-unstable.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit inputs user;};
      modules = [
        "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ./configurations/rpi3

        home-manager-unstable.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./homes/${user}.nix;
        }
      ];
    };

    images.rpi3 = nixosConfigurations.rpi3.config.system.build.sdImage;

    packages."aarch64-linux" = {
      fm_transmitter = pkgs.callPackage ./packages/fm_transmitter {};
    };
  };
}
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

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, deploy-rs, ... }@inputs: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    deployPkgs = import nixpkgs {
      overlays = [
        deploy-rs.overlay
        (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
      ];
    };

    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
  in rec {
    nixosConfigurations.rpi3 = nixpkgs-unstable.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ./configurations/rpi3

        home-manager-unstable.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ninjawarrior1337 = import ./homes/ninjawarrior1337.nix;
        }
      ];
    };


    nixosConfigurations.treeputer-nix = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        ({config, pkgs, ...}: 
          {
            nixpkgs.overlays = [overlay-unstable];
            nixpkgs.config.allowUnfree = true;
          }
        )

        ./configurations/treeputer-nix/configuration.nix
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs system; };
          home-manager.users.ninjawarrior1337 = import ./configurations/treeputer-nix/home.nix;
        }
      ];
    };


    images.rpi3 = nixosConfigurations.rpi3.config.system.build.sdImage;

    packages."aarch64-linux" = {
      fm_transmitter = pkgs.callPackage ./packages/fm_transmitter {};
    };

    deploy.nodes.rpi = {
      hostname = "192.168.1.177";
      profiles.system = {
        user = "root";
        sshUser = "ninjawarrior1337";
        magicRollback = false;
        path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.rpi3;
      };
    };
  };
}
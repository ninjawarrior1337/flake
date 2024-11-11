{
  description = "Treelar's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:MarceColl/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    user = "ninjawarrior1337";
    system = "x86_64-linux";

    pkgs = nixpkgs.legacyPackages.${system};
  in rec {
    nixosConfigurations.miku = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs user;};
      modules = [
        ./nixos/configurations/miku/configuration.nix
        ./home/nixosModule.nix

        home-manager.nixosModules.home-manager

        {
          nixpkgs.config.allowUnfree = true;
          nix.nixPath = [
            "nixpkgs=${nixpkgs}"
          ];
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
              zen-browser = inputs.zen-browser.packages.${final.system};
            })
          ];
        }
      ];
    };

    nixosConfigurations.thisismycomputernow = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        user = "nixos";
      };
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
        ./nixos/configurations/thisismycomputernow
        ./home/nixosModule.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];
        }
      ];
    };

    images.thisismycomputernow = nixosConfigurations.thisismycomputernow.config.system.build.isoImage;

    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        inputs.agenix.packages.${pkgs.system}.default
        bfg-repo-cleaner
      ];
    };
  };
}

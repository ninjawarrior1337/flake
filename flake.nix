{
  description = "Treelar's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  } @ inputs: let
    user = "ninjawarrior1337";
  in rec {
    nixosConfigurations.miku = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs user system;
      };
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
            self.overlays.default
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

    nixosConfigurations.thisismycomputernow = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
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
            inputs.self.overlays.default
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

    darwinConfigurations."shiki" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs user;};
      modules = [
        ./nixos/configurations/shiki

        home-manager.darwinModules.home-manager
        ./home/nixosModule.nix

        {
          nix.nixPath = [
            "nixpkgs=${nixpkgs}"
          ];
          nixpkgs = {
            overlays = [
              inputs.self.overlays.default
            ];
          };
        }
      ];
    };

    images.thisismycomputernow = nixosConfigurations.thisismycomputernow.config.system.build.isoImage;

    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          inputs.agenix.packages.${pkgs.system}.default
          bfg-repo-cleaner
        ];
      };

    overlays = {
      default = final: prev: {
        nebula-sans = final.callPackage ./packages/fonts/nebula-sans.nix {};
        apple-fonts = final.callPackage ./packages/fonts/apple.nix {};
        corporate-logo = final.callPackage ./packages/fonts/corporate-logo.nix {};
        agenix = inputs.agenix.packages.${final.system}.default;
        zen-browser = inputs.zen-browser.packages.${final.system}.default;
        helium = final.callPackage ./packages/helium.nix {};
      };
    };

    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in {
      nebula-sans = pkgs.callPackage ./packages/fonts/nebula-sans.nix {};
      apple-fonts = pkgs.callPackage ./packages/fonts/apple.nix {};
      corporate-logo = pkgs.callPackage ./packages/fonts/corporate-logo.nix {};
      helium = pkgs.callPackage ./packages/helium.nix {};
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}

{
  description = "Treelar's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/0403b4b7e8b2612657f0053a4c315e6c43eee9e6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";

    zed-editor = {
      url = "github:zed-industries/zed?ref=v1.7.2";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://zed.cachix.org"
    ];
    extra-trusted-public-keys = [
      "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    llm-agents,
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
            llm-agents.overlays.default
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
              inputs.llm-agents.overlays.default
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
          inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
          bfg-repo-cleaner
          nh
          just
        ];
      };

    overlays = {
      default = final: prev: {
        apple-fonts = final.callPackage ./packages/fonts/apple.nix {};
        corporate-logo = final.callPackage ./packages/fonts/corporate-logo.nix {};
        agenix = inputs.agenix.packages.${final.system}.default;
        zen-browser = inputs.zen-browser.packages.${final.system}.default;
        helium = final.callPackage ./packages/helium.nix {};
        kagi = final.callPackage ./packages/kagi-cli {};
        zed-editor = inputs.zed-editor.packages.${final.system}.default;
      };
    };

    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in {
      miku = nixosConfigurations.miku.config.system.build.toplevel;
      nebula-sans = pkgs.callPackage ./packages/fonts/nebula-sans.nix {};
      apple-fonts = pkgs.callPackage ./packages/fonts/apple.nix {};
      corporate-logo = pkgs.callPackage ./packages/fonts/corporate-logo.nix {};
      helium = pkgs.callPackage ./packages/helium.nix {};
      kagi-cli = pkgs.callPackage ./packages/kagi-cli {};
      update-helium = pkgs.writeShellApplication {
        name = "update-helium";
        runtimeInputs = with pkgs; [
          jq
          curl
          gnused
        ];
        text = builtins.readFile scripts/update-helium.sh;
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}

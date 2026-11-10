{
  description = "Treelar's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";
    llm-agents.inputs.flake-parts.follows = "flake-parts";

    # Local-first voice dictation. Follow our nixpkgs so Hex links against the
    # same glibc as the system graphics drivers (see hex docs/nix.md).
    hex.url = "github:anomalyco/hex";
    hex.inputs.nixpkgs.follows = "nixpkgs";
    hex.inputs.home-manager.follows = "home-manager";
  };

  outputs = inputs @ {flake-parts, ...}: let
    inherit (inputs) nixpkgs home-manager nix-darwin llm-agents;

    user = "ninjawarrior1337";

    overlays = {
      default = final: prev: {
        apple-fonts = final.callPackage ./packages/fonts/apple.nix {};
        corporate-logo = final.callPackage ./packages/fonts/corporate-logo.nix {};
        furifont-plex-sans = final.callPackage ./packages/fonts/furifont {
          base = final.ibm-plex.sans-jp + "/share/fonts/opentype/IBMPlexSansJP-Regular.otf";
          family = "Furifont Plex Sans";
        };
        agenix = inputs.agenix.packages.${final.stdenv.hostPlatform.system}.default;
        zen-browser = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.default;
        helium = final.callPackage ./packages/helium.nix {};
        kagi = final.callPackage ./packages/kagi-cli {};
      };

      # Kept separate from `default` so hosts that don't ask for Hex never
      # evaluate it (the upstream package is x86_64-linux only).
      hex = final: prev:
        prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-linux") {
          hex = inputs.hex.packages.x86_64-linux.default.overrideAttrs (old: {
            # Hex's dev branch currently has one UI test that fails inside the
            # Nix sandbox: rune_ui::tests::the_wheel_scrolls_the_model_picker
            # panics with "no element model-scroll". Keep the rest of the
            # suite; drop this once the input is bumped past the upstream fix.
            checkFlags =
              (old.checkFlags or [])
              ++ [
                "--skip"
                "rune_ui::tests::the_wheel_scrolls_the_model_picker"
              ];
          });
        };
    };

    nixosConfigurations = {
      miku = nixpkgs.lib.nixosSystem rec {
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
            nix.settings.nix-path = [
              "nixpkgs=${nixpkgs}"
            ];
            nixpkgs.overlays = [
              overlays.default
              overlays.hex
              llm-agents.overlays.shared-nixpkgs
            ];
          }
        ];
      };

      thisismycomputernow = nixpkgs.lib.nixosSystem rec {
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
              overlays.default
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
    };

    darwinConfigurations.shiki = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs user;};
      modules = [
        ./nixos/configurations/shiki

        home-manager.darwinModules.home-manager
        ./home/nixosModule.nix

        {
          nix.settings.nix-path = [
            "nixpkgs=${nixpkgs}"
          ];
          nixpkgs = {
            overlays = [
              overlays.default
              llm-agents.overlays.shared-nixpkgs
            ];
          };
        }
      ];
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      # `perSystem` outputs (packages, devShell and formatter) for every
      # supported system. `shiki` itself is exposed as a darwinConfiguration
      # above.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      flake = {
        inherit nixosConfigurations darwinConfigurations overlays;

        images.thisismycomputernow =
          nixosConfigurations.thisismycomputernow.config.system.build.isoImage;
      };

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) lib;
        isx86_64Linux = system == "x86_64-linux";
        isLinux = pkgs.stdenv.hostPlatform.isLinux;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
            bfg-repo-cleaner
            nh
            just
            stow
          ];
        };

        formatter = pkgs.alejandra;

        packages =
          {
            apple-fonts = pkgs.callPackage ./packages/fonts/apple.nix {};
            corporate-logo = pkgs.callPackage ./packages/fonts/corporate-logo.nix {};
            furifont-plex-sans = pkgs.callPackage ./packages/fonts/furifont {
              base = pkgs.ibm-plex.sans-jp + "/share/fonts/opentype/IBMPlexSansJP-Regular.otf";
              family = "Furifont Plex Sans";
            };
            update-helium = pkgs.writeShellApplication {
              name = "update-helium";
              runtimeInputs = with pkgs; [
                jq
                curl
                gnused
              ];
              text = builtins.readFile scripts/update-helium.sh;
            };
          }
          # The miku system closure only exists for x86_64-linux, and the
          # upstream Helium build is an x86_64 AppImage.
          // lib.optionalAttrs isx86_64Linux {
            miku = nixosConfigurations.miku.config.system.build.toplevel;
            helium = pkgs.callPackage ./packages/helium.nix {};
          }
          # kagi-cli only declares Linux support.
          // lib.optionalAttrs isLinux {
            kagi-cli = pkgs.callPackage ./packages/kagi-cli {};
          };
      };
    };
}

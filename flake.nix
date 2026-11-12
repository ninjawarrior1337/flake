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

    niri.url = "github:niri-wm/niri/main";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    hex.url = "github:anomalyco/hex";
    hex.inputs.nixpkgs.follows = "nixpkgs";
    hex.inputs.home-manager.follows = "home-manager";
  };

  outputs = inputs @ {flake-parts, ...}: let
    inherit (inputs) nixpkgs home-manager nix-darwin llm-agents;

    user = "ninjawarrior1337";
    mkPackages = pkgs: {
      apple-fonts = pkgs.callPackage ./packages/fonts/apple.nix {};
      corporate-logo = pkgs.callPackage ./packages/fonts/corporate-logo.nix {};
      furifont-plex-sans = pkgs.callPackage ./packages/fonts/furifont {
        base = pkgs.ibm-plex.sans-jp + "/share/fonts/opentype/IBMPlexSansJP-Regular.otf";
        family = "Furifont Plex Sans";
      };
      helium = pkgs.callPackage ./packages/helium.nix {};
      kagi-cli = pkgs.callPackage ./packages/kagi-cli {};
    };

    overlays = {
      default = final: prev:
        (mkPackages final)
        // {
          agenix = inputs.agenix.packages.${final.stdenv.hostPlatform.system}.default;
          zen-browser = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.default;
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
      };

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) lib;
        isx86_64Linux = system == "x86_64-linux";
        isLinux = pkgs.stdenv.hostPlatform.isLinux;
        sharedPackages = mkPackages pkgs;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
            bfg-repo-cleaner
            nh
            just
          ];
        };

        formatter = pkgs.alejandra;

        packages =
          {
            inherit (sharedPackages) apple-fonts corporate-logo furifont-plex-sans;
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
          # The upstream Helium build is an x86_64 AppImage.
          // lib.optionalAttrs isx86_64Linux {
            helium = sharedPackages.helium;
          }
          # kagi-cli only declares Linux support.
          // lib.optionalAttrs isLinux {
            inherit (sharedPackages) kagi-cli;
          };
      };
    };
}

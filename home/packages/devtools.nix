{kind ? "full"}: {
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = lib.asserts.assertOneOf "kind" kind [
            "full"
            "minimal"
          ];
        }
      ];

      home.packages = with pkgs; [
        ripgrep
        jujutsu
        gh

        nixd
        alejandra

        wrk
        hyperfine

        typst
      ];

      home.sessionPath = [
        "$HOME/.cargo/bin"
      ];

      programs.mise = {
        enable = true;
        enableZshIntegration = true;
        # On NixOS mise defaults to all_compile = true, forcing node/python/ruby/erlang
        # to build from source. miku has nix-ld, so precompiled glibc binaries run fine.
        globalConfig = {
          settings.all_compile = false;
          # mise owns these (rust backend = rustup under the hood; toolchains in ~/.rustup)
          tools = {
            uv = "latest";
            go = "latest";
            rust = "latest"; # stable
            opencode = "latest";
            node = "lts";
            claude = "latest"; # claude-code (registry alias)
            pi = "latest";
            java = "temurin-25"; # Temurin LTS (mise sets JAVA_HOME on activate)
          };
        };
      };
    }

    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      home.packages = with pkgs; [
        (python3.withPackages (
          pypkgs:
            with pypkgs; [
              pypdf
              pytesseract
            ]
        ))
        postgresql
      ];
    })

    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = with pkgs; [
        gcc
      ];
    })

    (lib.mkIf (kind == "full" && pkgs.stdenv.hostPlatform.isLinux) {
      programs.zed-editor = {
        enable = true;
        package = null;
        installRemoteServer = true;
        extensions = [
          "html"
          "toml"
          "sql"
          "nix"
          "kotlin"
          "dockerfile"
          "java"
          "typst"
          "go"
        ];
      };

      home.packages = with pkgs; [
        postgresql
        arduino-ide
        podman-desktop
        jetbrains-toolbox
        lmstudio
      ];
    })
  ];
}

{kind ? "full"}: {
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = lib.asserts.assertOneOf "kind" kind ["full" "minimal"];
        }
      ];

      home.packages = with pkgs; [
        uv
        rustup

        nodejs
        corepack

        go
        deno
        bun
        zulu

        nil
        alejandra

        wrk
        k6
      ];

      home.sessionPath = [
        "$HOME/.cargo/bin"
      ];
    }

    (lib.mkIf pkgs.stdenv.isDarwin {
      home.packages = with pkgs; [
        python3
        postgresql
      ];
    })

    (lib.mkIf pkgs.stdenv.isLinux {
      home.packages = with pkgs; [
        (python3.withPackages (pypkgs:
          with pypkgs; [
            pandas
            numpy
            duckdb
            polars
            pyarrow
            matplotlib
            seaborn
            pip
            virtualenv
            ipython
            notebook
            jupyter
          ]))

        duckdb
        gcc
      ];
    })

    (lib.mkIf (kind
      == "full"
      && pkgs.stdenv.isLinux) {
      home.packages = with pkgs; [
        postgresql
        arduino-ide
        podman-desktop
        jetbrains-toolbox
        vscode
      ];
    })
  ];
}

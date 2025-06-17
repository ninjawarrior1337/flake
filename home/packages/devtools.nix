{pkgs, ...}: {
  home.packages = with pkgs;
    [
      uv
      rustup

      nodejs
      corepack

      postgresql

      go
      deno
      bun
      zulu

      nil
      alejandra

      wrk
      k6
    ]
    ++ lib.optionals (pkgs.stdenv.isDarwin) [
      python3
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      arduino-ide

      podman-desktop
      jetbrains-toolbox
      vscode
      duckdb
      gcc

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
    ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}

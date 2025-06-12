{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    # Devtools
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
    uv
    rustup

    nodejs
    corepack

    go
    deno
    bun
    gcc
    zulu

    nil
    alejandra

    jetbrains-toolbox
    vscode
    postgresql
    duckdb

    arduino-ide
    podman-desktop

    k6
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}

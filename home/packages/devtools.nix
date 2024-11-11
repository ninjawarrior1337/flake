{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    # Devtools
    (python3.withPackages (pypkgs:
      with pypkgs; [
        pandas
        numpy
        pip
        virtualenv
      ]))
    poetry
    rustup

    nodejs
    corepack

    go
    deno
    bun
    gcc

    nil
    alejandra

    jetbrains-toolbox
    vscode
    duckdb
    postgresql
  ];
}

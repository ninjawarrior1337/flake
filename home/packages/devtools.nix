{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    # Devtools
    (python3.withPackages (pypkgs: [
      pypkgs.pandas
      pypkgs.numpy
      pypkgs.pip
    ]))
    rustup
    
    nodejs
    corepack

    go
    deno
    bun
    gcc
    # zsh-powerlevel10k
  ];
}

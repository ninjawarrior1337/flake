{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    # Devtools
    (python3.withPackages (pypkgs: [
      pypkgs.pandas
      pypkgs.numpy
    ]))
    rustup
    
    nodejs
    corepack

    go
    deno
    gcc
    # zsh-powerlevel10k
  ];
}

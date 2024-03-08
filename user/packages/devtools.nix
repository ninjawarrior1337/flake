{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    # Devtools
    (python3.withPackages (pypkgs: [
      pypkgs.pandas
      pypkgs.numpy
    ]))
    rustup
    nodejs
    go
    deno
    # zsh-powerlevel10k
  ];
}
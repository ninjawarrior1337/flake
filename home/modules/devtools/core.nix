# Baseline dev tooling, installed on every host that imports the devtools set.
{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      ripgrep
      fd
      jujutsu
      gh
      nixd
      alejandra
      hyperfine
      typst
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      gcc
    ];

  # mise's rust backend drives rustup, which installs into ~/.cargo/bin.
  home.sessionPath = ["$HOME/.cargo/bin"];

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };
}

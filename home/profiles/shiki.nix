{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../shell.nix
    ../git.nix
    ../packages/cli.nix
    ../packages/devtools.nix
  ];

  home.packages = with pkgs; [
    vesktop
    osu-lazer-bin
  ];

  home.stateVersion = "24.11";
}

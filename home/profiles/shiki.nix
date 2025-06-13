{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../shell.nix
  ];

  home.packages = with pkgs; [
    just
    jq
    wrk
    nil
    alejandra
    vesktop
    osu-lazer-bin
    micro
  ];

  home.stateVersion = "24.11";
}

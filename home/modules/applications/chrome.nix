{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--enable-wayland-ime"
    ];
  };
}

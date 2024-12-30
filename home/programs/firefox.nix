{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
  };
}

{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../shell.nix
    ../git.nix

    ../packages/cli.nix
  ];

  home.stateVersion = "24.05";
}

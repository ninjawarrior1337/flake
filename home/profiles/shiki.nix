{pkgs, ...}: {
  imports = [
    ../modules/shell.nix
    ../modules/git.nix
    ../modules/dotfiles.nix
    ../modules/cli.nix
    ../modules/devtools
  ];

  # Only the shared mise config; desktop dotfiles are Linux-only.
  treelar.dotfiles.groups = ["mise"];

  home.packages = with pkgs; [
    osu-lazer-bin
  ];

  home.stateVersion = "24.11";
}

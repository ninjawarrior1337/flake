{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../programs/chrome.nix
    ../shell.nix
    ../git.nix
    ../packages/cli.nix
  ];

  home.packages = with pkgs; [
    osu-lazer-bin
    prismlauncher

    chntpw
  ];

  home.stateVersion = "24.05";
}

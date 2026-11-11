{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hex.homeManagerModules.hex

    ../modules/shell.nix
    ../modules/git.nix
    ../modules/dotfiles.nix
    ../modules/dms.nix

    ../modules/cli.nix
    ../modules/devtools

    ../modules/applications/chrome.nix
    ../modules/applications/hacking.nix
    ../modules/applications/messaging.nix
    ../modules/applications/multimedia.nix
    # Plain Spotify instead of spicetify: ../modules/applications/spotify
    ../modules/applications/spotify/spicetify.nix
  ];

  # Desktop configs plus the shared mise config.
  treelar.dotfiles.groups = ["desktop" "mise" "wallpapers"];

  treelar.dms.wallpaper.enable = true;

  programs.hex = {
    enable = true;
    # Test-fixed build, see `overlays.hex` in flake.nix.
    package = pkgs.hex;
    # Start `hex service` with the graphical session (niri/hyprland both
    # activate graphical-session.target).
    autostart = true;
  };

  home.packages = with pkgs; [
    kagi-cli
    zen-browser
    llm-agents.t3code.unwrapped.desktop
  ];

  home.stateVersion = "24.05";
}

{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hex.homeManagerModules.hex

    ../programs/chrome.nix
    ../programs/spicetify.nix
    # ../programs/spotify.nix
    ../programs/hacking.nix
    # ../modules/gtk-theme.nix
    ../shell.nix
    ../git.nix
    ../packages
  ];

  programs.hex = {
    enable = true;
    # Test-fixed build, see `overlays.hex` in flake.nix.
    package = pkgs.hex;
    # Start `hex service` with the graphical session (niri/hyprland both
    # activate graphical-session.target).
    autostart = true;
  };

  home.packages = with pkgs; [
    kagi
    zen-browser
    # voxtype-vulkan — replaced by Hex (programs.hex).
    llm-agents.t3code.unwrapped.desktop
  ];

  home.stateVersion = "24.05";
}

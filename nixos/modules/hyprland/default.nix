{
  config,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.gvfs.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk];
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  services.gnome = {
    sushi.enable = true;
    gnome-keyring.enable = true;
  };

  # systemd.user.services.playerctld = {
  #   description = "playerctld last player tracking";
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.playerctl}/bin/playerctld daemon";
  #   };
  #   wantedBy = ["default.target"];
  # };

  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  programs.dms-shell = {
    enable = true;
    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
  };

  environment.systemPackages = with pkgs;
    [
      capitaine-cursors
      hyprpaper
      wiremix
      satty

      wl-clipboard
      pavucontrol
      cliphist
      hyprpicker
      slurp
      grim
      blueman
      hyprls
      playerctl
      ghostty
    ]
    ++ (with pkgs; [
      gnome-tweaks
      gnome-text-editor
      evince
      eog
      papers
      seahorse
      showtime
      dconf-editor
      nautilus
    ]);
}

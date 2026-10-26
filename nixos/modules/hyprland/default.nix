{
  config,
  pkgs,
  inputs,
  user,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.niri = {
    enable = true;
  };

  services.gvfs.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  services.gnome = {
    sushi.enable = true;
    gnome-keyring.enable = true;
  };

  systemd.user.services.playerctld = {
    description = "playerctld last player tracking";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.playerctl}/bin/playerctld daemon";
    };
    wantedBy = ["default.target"];
  };

  systemd.user.services.voxtype = {
    description = "voxtype push-to-talk voice-to-text daemon";
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.voxtype-vulkan}/bin/voxtype daemon";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";

  programs.dux-shell = {
    enable = false;
    # Theming (matugen) and the audio visualizer (cava) are now included in the
    # default Dux Shell environment. Exclude them via excludePackages if unwanted.
  };

  programs.noctalia = {
    enable =  true;
    systemd.enable =  true;
  };

  environment.systemPackages = with pkgs;
    [
      capitaine-cursors
      adwaita-icon-theme
      hyprpaper
      wiremix
      satty
      xwayland-satellite

      wl-clipboard
      pavucontrol
      cliphist
      hyprpicker
      slurp
      grim
      blueman
      hyprls
      playerctl
      kitty
      ghostty
      vicinae
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

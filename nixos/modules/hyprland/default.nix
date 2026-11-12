{pkgs, inputs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
  };

  services.gvfs.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.gnome = {
    sushi.enable = true;
    gnome-keyring.enable = true;
    at-spi2-core.enable = true;
  };

  systemd.user.services.playerctld = {
    description = "playerctld last player tracking";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.playerctl}/bin/playerctld daemon";
    };
    wantedBy = ["default.target"];
  };

  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  programs.dux-shell = {
    enable = true;
  };

  programs.noctalia = {
    enable = false;
    systemd.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
      bibata-cursors
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

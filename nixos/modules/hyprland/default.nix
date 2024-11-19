{
  config,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.waybar.enable = true;
  services.gvfs.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk];
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
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

  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";
    wayland.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
      kitty
      hyprpaper

      wl-clipboard
      fuzzel
      pavucontrol
      cliphist
      hyprpicker
      slurp
      grim
      blueman
      networkmanagerapplet
      hyprls
      playerctl

      kdePackages.breeze
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

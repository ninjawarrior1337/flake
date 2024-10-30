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
  services.displayManager.sddm.enable = true;
  services.gvfs.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk];
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
    ]
    ++ (with pkgs; [
      gnome-tweaks
      dconf-editor
      nautilus
    ]);
}

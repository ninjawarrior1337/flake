{
  config,
  pkgs,
}: {
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs;
    [gradience]
    ++ (with pkgs; [
      gnome-tweaks
      dconf-editor
      gnome-power-manager
    ])
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      gsconnect
      blur-my-shell
      caffeine
      vitals
    ]);
}

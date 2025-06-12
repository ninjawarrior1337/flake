{
  config,
  pkgs,
  ...
}: {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.seahorse.enable = true;

  environment.systemPackages =
    (with pkgs; [
      gnome-tweaks
      dconf-editor
      gnome-power-manager
      gradience
      ptyxis
    ])
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      gsconnect
      blur-my-shell
      caffeine
      vitals
    ]);
}

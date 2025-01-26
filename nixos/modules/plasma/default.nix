_: {
  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

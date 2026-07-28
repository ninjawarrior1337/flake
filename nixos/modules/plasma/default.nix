{pkgs, lib, ...}: {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = lib.mkDefault "plasma";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

{pkgs, lib, ...}: {
  services.displayManager.plasma-login-manager = {
    enable = true;
    theme = "breeze";
  };
  services.displayManager.defaultSession = lib.mkDefault "plasma";

  services.desktopManager.plasma6.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

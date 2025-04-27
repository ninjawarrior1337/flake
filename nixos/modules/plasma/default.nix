{pkgs, ...}: {
  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  environment.systemPackages = with pkgs; [
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.qtsvg
    kdePackages.qtwayland
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

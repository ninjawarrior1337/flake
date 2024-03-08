{ pkgs, ... }:
{
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  
  home.packages = (with pkgs.gnome; [
    gnome-tweaks
    dconf-editor
    gnome-power-manager
  ]) ++ (with pkgs.gnomeExtensions; [
    appindicator
    gsconnect
    blur-my-shell
    caffeine
    vitals
  ]);
}
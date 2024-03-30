{config, lib, inputs, pkgs, ...}: 
{
  services.openssh.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      enableNvidia = true;
    };
  };

  services.flatpak.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    jetbrains-mono
    meslo-lgs-nf
  ];

  services.tailscale = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    vlc
    mpv
    just
  ];

  programs.zsh.enable = true;
}
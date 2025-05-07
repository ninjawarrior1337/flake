{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  services.openssh.enable = true;

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    jetbrains-mono
    meslo-lgs-nf
    corporate-logo
    apple-fonts
    nebula-sans
    inter
    ibm-plex
  ];

  services.tailscale = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    just
    micro
    minicom
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  programs.zsh.enable = true;
}

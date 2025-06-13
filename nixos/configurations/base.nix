{
  config,
  lib,
  inputs,
  pkgs,
  user,
  ...
}: {
  imports = [
    ../modules/fonts.nix
  ];
  services.openssh.enable = true;

  nix.settings = {
    trusted-users = ["root" user];
  };

  virtualisation = {
    docker = {
      enable = true;
    };
  };

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

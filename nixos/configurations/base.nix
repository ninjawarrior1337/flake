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
    experimental-features = ["nix-command" "flakes"];
  };

  environment.systemPackages = with pkgs; [
    wget
    just
    fastfetch
    dua
    duf
    micro
    minicom
    htop
    btop
    p7zip
    jq
    file
    zstd
    zip
    unzip
    curl
    dig
  ];

  programs.zsh.enable = true;

  security.pki.certificateFiles = [
    "${inputs.self}/EikyuuRootA1.pem"
  ];
}

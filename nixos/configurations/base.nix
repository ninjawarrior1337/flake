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
    extra-substituters = [
      "https://zed.cachix.org"
    ];
    extra-trusted-public-keys = [
      "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
    ];
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
    comma
  ];

  programs.zsh.enable = true;

  security.pki.certificateFiles = [
    "${inputs.self}/EikyuuRootA1.pem"
  ];
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;
  networking.wireless.enable = true;

  networking.wireless.networks = {
    "Treelarwifi" = {
      pskRaw = (import ../../secrets.nix).wifiPasswordHash;
    };
  };

  boot.kernelParams = [
    "console=ttyS1,115200n8"
  ];

  networking.hostName = "rpi-nix";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    wget
    just
    neofetch
    zip
    xz
    unzip
    jq
    file
    zstd
    btop
    iftop
    iotop
    ffmpeg
    yt-dlp
    python3
    git
    htop
    libraspberrypi
    (callPackage ../../packages/fm_transmitter {})
  ];

  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
  };
  users.users.ninjawarrior1337 = {
    isNormalUser = true;
    description = "Treelar";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3UOTTll5RiIo7GkGQSQatdS0oJr9kECRQENy2LRPpv ninjawarrior1337@nixos"
    ];
    hashedPassword = (import ../../secrets.nix).userPasswordHash;
    shell = pkgs.zsh;
  };
  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;

  system.stateVersion = "23.11";

  imports = [
    ./hardware-configuration.nix
  ];

  # Preserve space by sacrificing documentation and history
  documentation.nixos.enable = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  boot.tmp.cleanOnBoot = true;
}

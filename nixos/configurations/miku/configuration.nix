# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../base.nix
    ./hardware-configuration.nix
    ../../modules/lanzaboote.nix
    ../../modules/nvidia.nix
    ../../modules/gaming.nix
    ../../modules/ime.nix
    ../../modules/hyprland
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  hardware.flipperzero.enable = true;
  hardware.ckb-next.enable = true;
  services.joycond.enable = true;
  programs.nix-ld.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "miku"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  programs.git.enable = true;
  programs.starship.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      extraConfig = {
        "suspend-audio-disable" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  # Matches all sinks
                  "node.name" = "~alsa_output.*";
                }
              ];
              actions = {
                "update-props" = {
                  "session.suspend-timeout-seconds" = 0;
                };
              };
            }
          ];
        };
      };
    };
    extraConfig.pipewire = {
      "91-raop-discover" = {
        context.modules = [
          {
            name = "libpipewire-module-raop-discover";
            args = {};
          }
        ];
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ninjawarrior1337 = {
    isNormalUser = true;
    description = "Tyler Rothleder";
    extraGroups = ["networkmanager" "wheel" "docker" "dialout"];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$gkH1ilVgDIo3yWwk68QCF0$q0foSnCcKP8t9U0oZuwDyUMoY3k4Fjvl3hhE728lU4B";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  virtualisation.docker.storageDriver = "btrfs";

  boot.loader.systemd-boot.configurationLimit = 3;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nix.settings.auto-optimise-store = true;

  nix.settings.trusted-users = ["root" "@wheel"];

  services.btrfs.autoScrub.enable = true;
  zramSwap.enable = true;

  systemd.services.alsa-disable-auto-mute = {
    description = "Update charge control threshold";
    script = ''
      ${pkgs.alsa-utils}/bin/amixer -c "PCH" sset "Auto-Mute Mode" Disabled
    '';
    wantedBy = ["graphical.target"]; # starts after login
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:778adaaf88f6";
  };

  systemd.services.iscsi-login-miku-gd = let
    tgt = "iqn.2024-07.xyz.treelar.maru:miku.gd";
    host = "192.168.0.3";
  in {
    description = "Login to iSCSI target ${tgt}";
    after = ["network.target" "iscsid.service"];
    restartIfChanged = false;
    wants = ["iscsid.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p ${host}";
      ExecStart = "-${pkgs.openiscsi}/bin/iscsiadm -m node -T ${tgt} -p ${host} --login";
      ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${tgt} -p ${host} --logout";
      RemainAfterExit = true;
    };
    wantedBy = ["multi-user.target"];
  };

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    openiscsi
    distrobox
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
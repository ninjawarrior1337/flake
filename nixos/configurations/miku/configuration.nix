# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}: {
  imports = [
    ../base.nix
    ./hardware-configuration.nix
    ../../modules/lanzaboote.nix
    ../../modules/nvidia.nix
    ../../modules/gaming.nix
    ../../modules/ime.nix
    # ../../modules/rtlsdr.nix
    ../../modules/gnome
    # ../../modules/plasma
    ./zfs.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_zen;
  services.scx.enable = true;
  services.scx.scheduler = "scx_lavd";

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  hardware.nvidia.open = true;

  hardware.flipperzero.enable = true;
  programs.nix-ld.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "miku"; # Define your hostname.
  networking.hostId = "66cf12fc";
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
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
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
      # "92-low-latency" = {
      #   "context.properties" = {
      #     "default.clock.rate" = 48000;
      #     "default.clock.quantum" = 128;
      #     "default.clock.min-quantum" = 64;
      #     "default.clock.max-quantum" = 128;
      #   };
      # };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Treelar";
    extraGroups = ["networkmanager" "wheel" "docker" "dialout"];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$gkH1ilVgDIo3yWwk68QCF0$q0foSnCcKP8t9U0oZuwDyUMoY3k4Fjvl3hhE728lU4B";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22 53317];
  networking.firewall.allowedUDPPorts = [53317];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
    };
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    waydroid.enable = true;
  };

  boot.loader.systemd-boot.configurationLimit = 3;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings = {
    auto-optimise-store = true;
    trusted-users = ["root" "@wheel"];
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:ninjawarrior1337/flake";
    dates = "3:00";

    allowReboot = true;
    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
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

  environment.systemPackages = with pkgs; [
    openiscsi
    distrobox

    # flatpak stuff
    flatpak-builder
    appstream
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  services.flatpak.enable = true;
  services.tailscale.enable = true;

  # Drop a link to the current system configuration flake in to /etc.
  # That way we can tell what configuration built the current
  # system version.
  environment.etc."current-system-flake".source = inputs.self;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:
{
  nix.settings.experimental-features = ["nix-command" "flakes" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.nvidia.open = lib.mkForce true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.flipperzero.enable = true;
  hardware.ckb-next.enable = true;
  services.joycond.enable = true;

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix
      ../../modules/nvidia.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "treeputer"; # Define your hostname.
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

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
        mozc
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
  sound.enable = true;
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
            args = { };
          }
        ];
      };
    };
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # environment.etc = let
  #   json = pkgs.formats.json {};
  # in {
  #   "pipewire/pipewire.conf.d/91-raop-discover.conf".source = json.generate "91-raop-discover.conf" {
  #     context.modules = [
  #       {
  #         name = "libpipewire-module-raop-discover";
  #         args = { };
  #       }
  #     ];
  #   };
  #   "wireplumber/wireplumber.conf.d/51-suspend-timeout.conf" = {
  #     text = ''
  #     monitor.alsa.rules = [
  #       {
  #         matches = [
  #           {
  #             # Matches all sinks
  #             node.name = "~alsa_output.*"
  #           }
  #         ]
  #         actions = {
  #           update-props = {
  #             session.suspend-timeout-seconds = 0
  #           }
  #         }
  #       }
  #     ]
  #     '';
  #   };
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ninjawarrior1337 = {
    isNormalUser = true;
    description = "Tyler Rothleder";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout"];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget


  # programs.steam = {
  #   enable = true;
  #   package = pkgs.unstable.steam;
  #   remotePlay.openFirewall = true;
  #   gamescopeSession.enable = true;
  #   extraCompatPackages = with pkgs; [
  #     unstable.proton-ge-bin
  #   ];
  # };

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  virtualisation.docker.storageDriver = "btrfs";

  boot.loader.systemd-boot.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;

  services.btrfs.autoScrub.enable = true;

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "nixpkgs-unstable"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  zramSwap.enable = true;

  programs.gnupg.agent = {
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

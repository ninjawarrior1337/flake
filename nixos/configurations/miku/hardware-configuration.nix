# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b6693e0c-4fdf-49d7-ba03-b71371f7863a";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
    ];
  };

  fileSystems."/real-root" = {
    device = "/dev/disk/by-uuid/b6693e0c-4fdf-49d7-ba03-b71371f7863a";
    fsType = "btrfs";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b6693e0c-4fdf-49d7-ba03-b71371f7863a";
    fsType = "btrfs";
    options = [
      "subvol=@nix-store"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b6693e0c-4fdf-49d7-ba03-b71371f7863a";
    fsType = "btrfs";
    options = [
      "subvol=home00"
      "compress=zstd"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/10e852bd-39ab-4715-ac78-b775171f38ee";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/8A65-43AA";
    fsType = "vfat";
  };

  fileSystems."/mnt/Miku" = {
    device = "/dev/disk/by-uuid/F6EF-BCEF";
    fsType = "exfat";
    options = [
      "nosuid"
      "nodev"
      "nofail"
      "x-gvfs-show"
      "uid=1000"
      "gid=100"
      "rw"
      "user"
      "exec"
      "umask=000"
    ];
  };

  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/e270e8ba-e74d-4977-a949-f8f423ea1f04";
    fsType = "ext4";
  };

  # swapDevices =
  #   [ { device = "/dev/disk/by-uuid/1ac630f4-eaf0-41c6-b2b8-df34db1e4d8e"; }
  #   ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

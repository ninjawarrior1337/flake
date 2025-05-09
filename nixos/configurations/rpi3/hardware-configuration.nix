{
  config,
  pkgs,
  lib,
  ...
}: {
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 1024;
    }
  ];
  networking.useDHCP = lib.mkDefault true;
}

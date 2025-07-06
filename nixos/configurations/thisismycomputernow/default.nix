{
  config,
  inputs,
  pkgs,
  user,
  ...
}: {
  isoImage.squashfsCompression = "zstd";

  users.users.${user} = {
    shell = pkgs.zsh;
  };

  networking.hostName = "thisismycomputernow";

  services.xserver.enable = true;

  imports = [
    ../base.nix
    ../../modules/ime.nix
    ../../modules/nvidia.nix
  ];
}

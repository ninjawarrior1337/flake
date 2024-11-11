{
  config,
  inputs,
  pkgs,
  user,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
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

{config, inputs, pkgs, user, ...}: 
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  isoImage.squashfsCompression = "zstd";

  users.users.${user} = {
    shell = pkgs.zsh;
  };

  networking.hostName = "thisismycomputernow";

  imports = [
    ../base.nix
    ../../modules/nvidia.nix
  ];
}
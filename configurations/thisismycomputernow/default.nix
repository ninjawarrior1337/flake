{config, inputs, pkgs, user, ...}: 
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  isoImage.squashfsCompression = "zstd";

  users.users.${user} = {
    shell = pkgs.zsh;
  };

  networking.hostName = "thisismycomputernow";

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
        mozc
    ];
  };

  services.xserver.enable = true;

  imports = [
    ../base.nix
    ../../modules/nvidia.nix
  ];
}
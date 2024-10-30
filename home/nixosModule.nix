{
  config,
  inputs,
  system,
  user,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit inputs system;};
  home-manager.backupFileExtension = "bak";
  home-manager.users.${user} = import ./profiles/${config.networking.hostName}.nix;
}

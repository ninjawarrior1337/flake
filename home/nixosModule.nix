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

  # Per-host user config, selected by hostname so the profiles stay one
  # directory away from the modules (`../modules/...`) and hosts never need
  # `../../../` paths.
  home-manager.users.${user} = import ./profiles/${config.networking.hostName}.nix;
}

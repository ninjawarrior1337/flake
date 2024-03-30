{ config, inputs, user, system, ... }: 
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs user system; };
  home-manager.users.${user} = import ./profiles/${config.networking.hostName}.nix;
  
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
    })
  ];
}
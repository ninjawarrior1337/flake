# Plain Spotify, no spicetify. Mutually exclusive with ./spicetify.nix —
# enable one or the other in the profile.
{pkgs, ...}: {
  home.packages = [(import ./package.nix {inherit pkgs;})];
}

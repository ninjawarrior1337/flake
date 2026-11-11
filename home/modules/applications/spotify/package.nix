# nixpkgs' Spotify with libspotifyadblock preloaded, so the spicetify
# extensions (including `adblock`) apply to an ad-free client.
#
# Linux-only and unfree, which is why it lives next to the two modules that use
# it instead of going through the flake overlay (`mkPackages` in flake.nix).
{pkgs}: let
  spotify-adblock = pkgs.callPackage ./spotify-adblock.nix {};
in
  pkgs.spotify.overrideAttrs (prev: {
    postInstall =
      (prev.postInstall or "")
      + ''
        wrapProgram $out/bin/spotify \
          --set LD_PRELOAD "${spotify-adblock}/lib/libspotifyadblock.so"
      '';
  })

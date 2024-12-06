{
  spotify,
  spotify-adblock,
}:
spotify.overrideAttrs (
  prev: {
    postInstall =
      (prev.postInstall or "")
      + ''
        # wrap spotify to use libspotifyadblock.so
        wrapProgram $out/bin/spotify \
          --set LD_PRELOAD "${spotify-adblock}/lib/libspotifyadblock.so"
      '';
  }
)

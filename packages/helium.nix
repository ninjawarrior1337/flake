{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  runCommand,
  commandLineArgs ? [],
}: let
  version = "0.13.2.1";
  pname = "helium";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-I9VqXE20FNjEz9FyvcCZ8ZqRZbPIU+QtGPblAdwJRk8=";
  };
  appimageContents = appimageTools.extract {inherit pname version src;};
  unwrapped = appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/helium.desktop $out/share/applications/helium.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/helium.png \
        $out/share/icons/hicolor/256x256/apps/helium.png
    '';

    meta = {
      description = "Private, fast, and honest web browser ";
      homepage = "https://helium.computer";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = ["x86_64-linux"];
    };
  };
in
  if commandLineArgs == []
  then unwrapped
  else
    runCommand "${pname}-${version}" {
      nativeBuildInputs = [makeWrapper];
      inherit (unwrapped) meta;
    } ''
      mkdir -p $out/bin
      makeWrapper ${unwrapped}/bin/helium $out/bin/helium \
        --add-flags ${lib.escapeShellArg (lib.concatStringsSep " " commandLineArgs)}

      # Symlink other top-level directories from the unwrapped package
      for dir in ${unwrapped}/*; do
        if [ "$(basename "$dir")" != "bin" ]; then
          ln -s "$dir" $out/
        fi
      done

      # Symlink any other binaries from the unwrapped package
      for f in ${unwrapped}/bin/*; do
        if [ "$(basename "$f")" != "helium" ]; then
          ln -s "$f" $out/bin/
        fi
      done
    ''

{
  pkgs,
  lib,
  ...
}: {
  # arduino-ide is x86_64-linux only and vm-curator is Linux only, while the
  # full set is imported on both hosts, so the guard belongs next to the
  # packages rather than in the importer.
  home.packages = with pkgs;
    lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      arduino-ide
      jetbrains-toolbox
      lmstudio
      vm-curator
    ];
}

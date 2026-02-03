{
  pkgs,
  lib,
  ...
}: {
  fonts.packages = with pkgs;
    [
      noto-fonts
      noto-fonts-cjk-sans
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nebula-sans
      inter
      ibm-plex
    ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      corporate-logo
      corefonts
      vista-fonts
    ];
}

{pkgs, lib, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    jetbrains-mono
    meslo-lgs-nf
    nebula-sans
    inter
    ibm-plex
  ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [
    corporate-logo
    apple-fonts
  ];
}

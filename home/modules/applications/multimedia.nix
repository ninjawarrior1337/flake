{pkgs, ...}: {
  home.packages = with pkgs; [
    audacity
    vlc
    mpv

    kdePackages.kdenlive
    obs-studio

    # Graphics
    gimp
    inkscape
  ];
}

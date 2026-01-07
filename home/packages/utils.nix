{pkgs, ...}: {
  home.packages = with pkgs; [
    audacity
    vlc
    mpv
    kdePackages.kdenlive
    kdePackages.kleopatra
    obs-studio
    discordchatexporter-cli

    # Productivity
    blender
    gimp
    inkscape
    telegram-desktop
    yaak
    openscad-unstable
    zoom-us
    thunderbird
    ente-auth
  ];
}

{pkgs, ...}: {
  home.packages = with pkgs; [
    audacity
    vlc
    mpv

    # kdePackages.kdenlive
    kdePackages.kleopatra
    obs-studio
    discordchatexporter-cli

    # Productivity
    gimp
    inkscape
    telegram-desktop
    # openscad-unstable
    zoom-us
    thunderbird
    ente-auth
  ];
}

{pkgs, ...}: {
  home.packages = with pkgs; [
    audacity
    vlc
    mpv
    kdePackages.kdenlive
    obs-studio
    discordchatexporter-cli

    # Productivity
    blender
    gimp
    inkscape
    telegram-desktop
    postman
    openscad-unstable
    zoom-us
    thunderbird
  ];
}

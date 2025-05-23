{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    audacity
    vlc
    mpv
    kdePackages.kdenlive
    obs-studio
    discordchatexporter-cli

    # Productivity
    blender
    gimp
    obsidian
    telegram-desktop
    postman
    openscad-unstable
    nil
    zoom-us
  ];
}

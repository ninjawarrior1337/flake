{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    audacity
    vlc
    mpv
    kdenlive
    obs-studio
    orca-slicer
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

{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    audacity
    kdenlive
    obs-studio
    bambu-studio
    vscode

    # Productivity
    blender
    gimp
    obsidian
    telegram-desktop
    postman
    jetbrains-toolbox
    openscad-unstable
    nil
    zoom-us
  ];
}
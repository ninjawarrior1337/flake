{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    audacity
    kdenlive
    obs-studio
    orca-slicer
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
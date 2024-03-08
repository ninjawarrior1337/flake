{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    armcord
    discord-screenaudio
    # osu-lazer-bin
    dolphin-emu
    ryujinx
  ];
}
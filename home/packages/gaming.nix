{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    armcord
    discord-screenaudio
    dolphin-emu
    ryujinx
  ];
}
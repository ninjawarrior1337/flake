{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    vesktop
    dolphin-emu
    ryujinx
    # heroic
  ];
}

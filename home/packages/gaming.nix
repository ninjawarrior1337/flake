{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
    dolphin-emu
    ryujinx
    # heroic
  ];
}

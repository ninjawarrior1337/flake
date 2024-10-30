{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    fastfetch
    zip
    unzip
    p7zip

    jq
    file
    zstd

    btop
    htop
    iftop
    iotop

    lsof
    usbutils
    pciutils

    yt-dlp
    ffmpeg
    iperf3

    dua
    duf
  ];
}

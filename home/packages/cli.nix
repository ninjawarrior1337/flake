{pkgs, lib, ...}: {
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
    psmisc
    smartmontools
    fio
    openssl

    yt-dlp
    ffmpeg
    aria2
    iperf3

    dua
    duf

    step-cli
    step-kms-plugin
  ];
}

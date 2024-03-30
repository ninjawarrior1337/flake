{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    neofetch
    zip
    xz
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
    yt-dlp
    ffmpeg
  ];
}
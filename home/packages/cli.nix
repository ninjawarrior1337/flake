{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs.unstable;
    [
      micro
      fastfetch
      zip
      unzip
      p7zip

      jq
      file
      just
      zstd

      btop
      htop

      openssl

      yt-dlp
      ffmpeg
      aria2
      iperf3

      dua
      duf

      step-cli
      spoof
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      step-kms-plugin

      lsof
      usbutils
      pciutils
      psmisc
      smartmontools
      fio

      iftop
      iotop
    ];
}

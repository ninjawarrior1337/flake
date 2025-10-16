{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      openssl

      yt-dlp
      ffmpeg-full
      aria2
      iperf3

      step-cli
      spoof
      restic
      rclone
      ansible
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      # step-kms-plugin

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

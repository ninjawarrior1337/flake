{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      openssl

      yt-dlp
      aria2
      iperf3

      step-cli
      restic
      rclone

      herdr
    ]
    ++ lib.optionals (pkgs.stdenv.isDarwin) [
      ffmpeg
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      # step-kms-plugin

      lsof
      usbutils
      pciutils
      psmisc
      smartmontools
      fio
      ffmpeg-full

      iftop
      iotop
    ];
}

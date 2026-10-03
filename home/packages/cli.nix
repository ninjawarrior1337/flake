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
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
      ffmpeg
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      # step-kms-plugin

      lsof
      bubblewrap
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

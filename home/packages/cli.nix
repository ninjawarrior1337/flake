{
  pkgs,
  lib,
  inputs,
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
      restic
      rclone
      ansible

      llm-agents.opencode

      nh
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

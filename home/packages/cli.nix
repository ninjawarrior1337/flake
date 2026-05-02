{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      openssl

      yt-dlp
      aria2
      iperf3

      step-cli
      restic
      rclone
      ansible

      llm-agents.opencode
      llm-agents.pi

      nh
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

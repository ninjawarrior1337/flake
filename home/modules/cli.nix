# Cross-platform CLI baseline: tools both the Linux and the Darwin host want.
# Platform-specific extras stay in the matching `lib.optionals` block.
{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      openssl

      # media / transfer
      yt-dlp
      aria2
      iperf3

      # secrets, backups, sync
      step-cli
      restic
      rclone
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      ffmpeg
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      # process / hardware inspection
      lsof
      usbutils
      pciutils
      psmisc
      smartmontools

      # benchmarking and sandboxing
      fio
      bubblewrap

      ffmpeg-full
    ];
}

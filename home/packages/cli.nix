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
      ansible

      llm-agents.opencode
      llm-agents.pi
      claude-code
      (symlinkJoin {
        name = "claude-code-oc";
        paths = [claude-code];
        buildInputs = [makeWrapper];
        postBuild = ''
          makeWrapper ${claude-code}/bin/claude $out/bin/claude-oc \
            --set ANTHROPIC_BASE_URL "https://cliproxyapi.tail5158.ts.net" \
            --set ANTHROPIC_API_KEY "sk-ant-dummy-key" \
            --set ANTHROPIC_DEFAULT_OPUS_MODEL "kimi-k2.7-code" \
            --set ANTHROPIC_DEFAULT_SONNET_MODEL "deepseek-v4-pro" \
            --set ANTHROPIC_DEFAULT_HAIKU_MODEL "deepseek-v4-flash"
        '';
      })

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

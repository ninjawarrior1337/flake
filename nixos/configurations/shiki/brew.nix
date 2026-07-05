_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
      # extraFlags = [
      #   "--force-cleanup"
      # ];
    };
    caskArgs = {
      no_quarantine = false;
    };
    taps = [
      { name = "apple/apple"; trusted = true; }
      { name = "borgbackup/tap"; trusted = true; }
      { name = "emqx/mqttx"; trusted = true; }
      "homebrew/cask"
      "homebrew/core"
      "homebrew/services"
      { name = "hpedrorodrigues/tools"; trusted = true; }
      { name = "localsend/localsend"; trusted = true; }
      { name = "oven-sh/bun"; trusted = true; }
      { name = "RfidResearchGroup/proxmark3"; trusted = true; }
      { name = "garethgeorge/homebrew-backrest-tap"; trusted = true; }
    ];
    brews = [
      "aircrack-ng"
      {
        name = "backrest";
        restart_service = "changed";
      }
      "duckdb"
      "cloudflared"
      "cowsay"
      "croc"
      "dex2jar"
      "fdroidserver"
      "flyctl"
      "ghidra"
      "imagemagick"
      "lame"
      "llvm"
      "lsusb"
      "lua"
      "luajit"
      "mas"
      "masscan"
      "megatools"
      "mosh"
      "mpg123"
      "netcat"
      "nmap"
      "pinentry-mac"
      "postgrest"
      {
        name = "rfidresearchgroup/proxmark3/proxmark3";
        args = ["with-generic"];
      }
      "python@3.12"
      "smartmontools"
      "tesseract"
      "typst"
      "ykman"
    ];
    casks = [
      "aegisub"
      "android-file-transfer"
      "android-platform-tools"
      "android-studio"
      "azure-data-studio"
      "anki"
      "arduino-ide"
      "audacity"
      "barrier"
      "basictex"
      "beekeeper-studio"
      "betterzip"
      "blender"
      "blockbench"
      "cyberduck"
      "docker-desktop"
      "dolphin"
      "duplicati"
      "ente-auth"
      "flutter"
      "ghostty"
      "gimp"
      "gitkraken"
      "google-chrome"
      "gpg-suite"
      "grandperspective"
      "gqrx"
      "handbrake-app"
      "helium-browser"
      "hiddenbar"
      "iina"
      "inkscape"
      "jetbrains-toolbox"
      "jordanbaird-ice@beta"
      "keka"
      "linearmouse"
      "localsend"
      "maccy"
      "macfuse"
      "macs-fan-control"
      "microsoft-teams"
      "mochi-diffusion"
      "moonlight"
      "mounty"
      "notion"
      "obs"
      "obsidian"
      "openscad@snapshot"
      "orcaslicer"
      "parsec"
      "prismlauncher"
      "postman"
      "raycast"
      "rectangle"
      "signal"
      "spotify"
      "stats"
      "steam"
      "telegram"
      "tor-browser"
      "transmission"
      "utm"
      "veracrypt"
      "vesktop"
      "visual-studio-code"
      "vlc"
      "vnc-viewer"
      "vorta"
      "warp"
      "whisky"
      "wireshark-app"
      "xquartz"
      "yubico-authenticator"
      "zed@preview"
      "zoom"
      "zulu"
    ];
  };
}

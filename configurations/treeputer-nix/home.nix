{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ninjawarrior1337";
  home.homeDirectory = "/home/ninjawarrior1337";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  home.packages = with pkgs.unstable; [
    armcord
    discord-screenaudio
    osu-lazer-bin
    bambu-studio      

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

    # Media
    audacity
    kdenlive
    obs-studio
    ffmpeg
    yt-dlp

    # Devtools
    python3
    rustup
    nodejs
    go
    deno
    zsh-powerlevel10k

    # Productivity
    blender
    gimp
    obsidian
    telegram-desktop
    postman
    jetbrains-toolbox
    nil  
  ];

  programs.git = {
    enable = true;
    userName = "ninjawarrior1337";
    userEmail = "me@treelar.xyz";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ../../homes/p10k-config;
        file = "p10k.zsh";
      }
    ];
  };
}

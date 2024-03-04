{config, pkgs, stdenv, ...}:

rec {
  home.username = "ninjawarrior1337";
  home.homeDirectory = if stdenv.isDarwin then
     "/Users/ninjawarrior1337"
    else
      "/home/${home.username}";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

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
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];
  };
}
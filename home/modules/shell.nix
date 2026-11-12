{lib, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initContent = lib.mkMerge [
      (lib.mkOrder 790 ''
        plugins=(git sudo docker)
      '')
      (lib.mkOrder 1190 ''
        if [ -n "$REX_BIN_DIR" ]; then
          export PATH="$REX_BIN_DIR:$PATH"
        fi
        if [ -d "$HOME/.local/bin" ]; then
          export PATH="$HOME/.local/bin:$PATH"
        fi
      '')
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [];
    };
    # Set up Homebrew environment for login shells
    profileExtra = ''
      # Homebrew
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';
  };

  programs.nushell = {
    enable = true;
    loadSessionVariables = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}

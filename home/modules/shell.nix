{lib, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initContent = lib.mkMerge [
      (lib.mkOrder 790 ''
        plugins=(git sudo docker)
      '')
      # Nix sets PATH to a fixed list, which drops the directory Rex puts in
      # front of PATH for its `rex` CLI. Re-prepend it for interactive shells,
      # after oh-my-zsh and the rest of the startup files. No-op outside Rex,
      # where REX_BIN_DIR is unset.
      # https://www.superlogical.com/rex/docs/automate/cli#nix
      (lib.mkOrder 1190 ''
        if [ -n "$REX_BIN_DIR" ]; then
          export PATH="$REX_BIN_DIR:$PATH"
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

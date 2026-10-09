{lib, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # Home Manager master currently trips over oh-my-zsh.plugins during eval,
    # so define the plugin list manually before oh-my-zsh is sourced.
    initContent = lib.mkOrder 790 ''
      plugins=(git sudo docker)
    '';
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

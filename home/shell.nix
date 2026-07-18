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
    shellAliases = {
      xclaude = ''
        ANTHROPIC_BASE_URL=https://cliproxyapi.tail5158.ts.net \
        ANTHROPIC_AUTH_TOKEN=sk-dummy \
        ANTHROPIC_DEFAULT_OPUS_MODEL=kimi-k2.7-code \
        ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro \
        ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash \
        CLAUDE_CODE_ALWAYS_ENABLE_EFFORT=1 \
        CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY=3 \
        ENABLE_TOOL_SEARCH=false \
        claude
      '';
    };
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

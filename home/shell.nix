{pkgs, ...}: {
  programs.zsh = {
    enable = false;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "sudo" "docker"];
    };
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

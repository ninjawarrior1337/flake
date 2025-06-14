{
  pkgs,
  inputs,
  user,
  ...
}: {
  imports = [
    ../base.nix
    ./brew.nix
    ../../modules/darwin
    ../../modules/fonts.nix
  ];

  networking.hostName = "shiki";
  # Auto upgrade nix package and the daemon service.
  nix.enable = true;

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "maru";
      protocol = "ssh";
      sshKey = "/Users/${user}/.ssh/id_ed25519";
      sshUser = "ninjawarrior1337";
      systems = ["x86_64-linux"];
    }
    {
      hostName = "miku";
      protocol = "ssh";
      sshKey = "/Users/${user}/.ssh/id_ed25519";
      sshUser = "ninjawarrior1337";
      systems = ["x86_64-linux"];
    }
  ];

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 7;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 7d";
  };

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  system.primaryUser = user;
  security.pam.services.sudo_local.touchIdAuth = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}

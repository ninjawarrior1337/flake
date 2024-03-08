{inputs, ...}:

{
  imports = [
    ./desktop/gnome.nix
    ./programs/chrome.nix
    ./programs/spicetify.nix
    ./programs/hacking.nix
    ./shell.nix
    ./packages
  ];

  services.hacking.enable = true;

  programs.git = {
    enable = true;
    userName = "ninjawarrior1337";
    userEmail = "me@treelar.xyz";
  };

  home.stateVersion = "23.11";
}
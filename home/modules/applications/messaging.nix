{pkgs, ...}: {
  home.packages = with pkgs; [
    discordchatexporter-cli
    telegram-desktop
  ];
}

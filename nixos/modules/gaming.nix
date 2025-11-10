{pkgs, ...}: {
  programs.steam = {
    enable = true;
    package = pkgs.unstable.steam;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs.unstable; [
      proton-ge-bin
    ];
  };

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs.unstable; [
    osu-lazer-bin
    heroic
    protonup-qt
    protonplus
    mangohud
    bottles
  ];
}

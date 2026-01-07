{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.panel = "${pkgs.kdePackages.plasma-desktop}/libexec/kimpanel-ibus-panel";
    ibus.engines = with pkgs.ibus-engines; [
      mozc-ut
    ];
  };
}

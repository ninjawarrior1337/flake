{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    ghidra
    aircrack-ng
    hashcat
    wireshark
    burpsuite
    nmap
    masscan
    metasploit
    (proxmark3.override {
      withGeneric = true;
    })
  ];

  # REA (https://rea.tools) native Ghidra provider looks up
  # $GHIDRA_INSTALL_DIR (see docs/installation.md#ghidra).
  # On nixpkgs the install root (support/analyzeHeadless, Ghidra/, etc.)
  # lives at <ghidra>/lib/ghidra, not <ghidra> itself.
  home.sessionVariables = {
    GHIDRA_INSTALL_DIR = "${pkgs.ghidra}/lib/ghidra";
  };
}

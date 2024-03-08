{config, pkgs, lib, ...}:
let
  cfg = config.services.hacking;
in
{
  options.services.hacking = with lib; {
    enable = mkEnableOption "hacking tools";
  };

  config = lib.mkIf cfg.enable {
      home.packages = with pkgs.unstable; [
      ghidra
      aircrack-ng
      hashcat
      wireshark
      burpsuite
      nmap
      masscan
      metasploit
    ];
  };
}
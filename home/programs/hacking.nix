{config, pkgs, lib, ...}:
{
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
}
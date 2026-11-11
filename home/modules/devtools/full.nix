# Everything in ./core.nix plus the interactive/GUI dev stack. Import `./core.nix`
# directly on hosts that should stay lean (servers, VMs, remote builders).
{pkgs, ...}: {
  imports = [
    ./core.nix
    ../applications/zed.nix
    ../applications/dev.nix
  ];

  home.packages = with pkgs; [
    postgresql
  ];
}

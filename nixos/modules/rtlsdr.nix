{
  pkgs,
  user,
  ...
}: {
  hardware.rtl-sdr.enable = true;
  users.users.${user}.extraGroups = ["plugdev"];

  environment.systemPackages = with pkgs; [
    rtl-sdr
    gqrx
  ];
}

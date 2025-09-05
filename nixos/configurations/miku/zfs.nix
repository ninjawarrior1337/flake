{
  user,
  pkgs,
  ...
}: {
  services.sanoid = {
    enable = true;
    templates.backup = {
      hourly = 2;
      daily = 7;
      monthly = 3;

      autoprune = true;
      autosnap = true;
    };

    datasets."zpool/home" = {
      useTemplate = ["backup"];
    };
  };

  # boot.extraModprobeConfig = ''
  #   options zfs l2arc_noprefetch=0
  # '';

  systemd.services.syncoid-nas = {
    description = "Syncoid backup to nas server";
    after = ["sanoid.service"];
    wantedBy = ["sanoid.service"];
    serviceConfig = {
      ExecStart = "${pkgs.sanoid}/bin/syncoid --compress zstd-fast --no-privilege-elevation --preserve-properties --no-sync-snap --delete-target-snapshots zpool/home ninjawarrior1337@maru:tank/backups/miku/home";
      User = user;
    };
    path = [pkgs.openssh pkgs.sanoid pkgs.zfs];
  };
}

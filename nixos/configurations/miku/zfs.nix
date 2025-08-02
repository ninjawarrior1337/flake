{user, ...}: {
  services.sanoid = {
    enable = true;
    templates.backup = {
      hourly = 2;
      daily = 30;
      monthly = 3;

      autoprune = true;
      autosnap = true;
    };

    datasets."zpool/home" = {
      useTemplate = ["backup"];
    };
  };

  services.syncoid = {
    enable = true;
    sshKey = "/home/${user}/.ssh/id_rsa";
    commonArgs = [
      "--compress=zstd-fast"
    ];

    commands."zpool/home" = {
      target = "ninjawarrior1337@maru:tank/backups/miku/home";
    };
  };
}

{lib, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;

    # Defaults only: profiles can override individual values.
    settings.user = {
      name = lib.mkDefault "ninjawarrior1337";
      email = lib.mkDefault "me@treelar.xyz";
    };
    signing = {
      key = lib.mkDefault "0EF8F87BCB6BDB63";
      signByDefault = lib.mkDefault true;
      format = lib.mkDefault "openpgp";
    };
  };
}

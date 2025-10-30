_: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ninjawarrior1337";
        email = "me@treelar.xyz";
      };
    };
    lfs.enable = true;
    signing = {
      key = "0EF8F87BCB6BDB63";
      signByDefault = true;
    };
  };
}

_: {
  programs.git = {
    enable = true;
    userName = "ninjawarrior1337";
    userEmail = "me@treelar.xyz";
    lfs.enable = true;
    signing = {
      key = "0EF8F87BCB6BDB63";
      signByDefault = true;
    };
  };
}

_: {
  programs.zed-editor = {
    enable = true;
    package = null;
    installRemoteServer = true;
    extensions = [
      "html"
      "toml"
      "sql"
      "nix"
      "kotlin"
      "dockerfile"
      "java"
      "typst"
      "go"
    ];
  };
}

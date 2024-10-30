{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.chromium = {
    enable = true;
    package = pkgs.unstable.chromium;
    commandLineArgs = [
      "--enable-wayland-ime"
    ];

    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "likgccmbimhjbgkjambclfkhldnlhbnn" # yomitan
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "fmkadmapgofadopljbjfkapdkoienihi" # react dev tools
      "gbmdgpbipfallnflgajpaliibnhdgobh" # json viewer
      "ammjkodgmmoknidbanneddgankgfejfh" # 7tv
      "bkkjeefjfjcfdfifddmkdmcpmaakmelp" # truffle
    ];
  };
}

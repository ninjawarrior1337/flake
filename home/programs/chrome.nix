{ pkgs, lib, inputs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.unstable.chromium;

    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "likgccmbimhjbgkjambclfkhldnlhbnn" # yomitan
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "fmkadmapgofadopljbjfkapdkoienihi" # react dev tools
      "gbmdgpbipfallnflgajpaliibnhdgobh" # json viewer
      "lkgcfobnmghhbhgekffaadadhmeoindg" # purple ads blocker
      "ammjkodgmmoknidbanneddgankgfejfh" # 7tv
      "bkkjeefjfjcfdfifddmkdmcpmaakmelp" # truffle
    ];
  };
}
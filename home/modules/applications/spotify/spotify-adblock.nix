{
  rustPlatform,
  fetchFromGitHub,
  rust,
  stdenv,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "spotify-adblock";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "abba23";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-R1xM/a+EzFd3I94EVCphbW+M114x6CtIeCOi9Fd9tpc=";
  };

  cargoHash = "sha256-gxGetdqaoJa/ZF1VnW6UXJyJfLBGZxZnyKpT/Qk/8Og=";

  patchPhase = ''
    substituteInPlace src/lib.rs \
      --replace 'config.toml' $out/etc/spotify-adblock/config.toml
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc/spotify-adblock $out/lib
    install -Dm644 config.toml $out/etc/spotify-adblock
    install -Dm644 target/${stdenv.buildPlatform.rust.rustcTargetSpec}/release/libspotifyadblock.so $out/lib

    runHook postInstall
  '';
}

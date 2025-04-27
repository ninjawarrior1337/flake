{
  rustPlatform,
  fetchFromGitHub,
  rust,
  stdenv,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "spotify-adblock";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "abba23";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UzpHAHpQx2MlmBNKm2turjeVmgp5zXKWm3nZbEo0mYE=";
  };

  cargoHash = "sha256-oGpe+kBf6kBboyx/YfbQBt1vvjtXd1n2pOH6FNcbF8M=";

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

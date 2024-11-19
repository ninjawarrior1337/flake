{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "flipper-pc-monitor-backend";
  version = "master";

  src = fetchFromGitHub {
    owner = "ninjawarrior1337";
    repo = pname;
    rev = version;
    hash = "sha256-q/G6xSa7GUWnApvQNrEfXR98+gUXj32vbMYjf7iCOlY=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    dbus
  ];

  cargoLock.lockFile = "${src}/Cargo.lock";

  cargoLock.outputHashes = {
    "xmltojson-0.1.3" = "sha256-+BDU3nihDA7f4T56IAQRgAERew52TC7hVNtXvF8IhXU=";
  };

  meta = with lib; {
    description = "A fast line-oriented regex search tool, similar to ag and ack";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = licenses.mit;
    maintainers = [maintainers.tailhook];
  };
}

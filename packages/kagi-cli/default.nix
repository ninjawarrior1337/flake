{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "kagi";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Microck";
    repo = "kagi-cli";
    rev = "v0.9.0";
    hash = "sha256-d5eej1ZhMN3ogrLix8KFIt/z1eFcdYDT5g2kxuE/IZQ=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  # 6 integration tests spawn temp scripts from tempdir() which fails in
  # the Nix sandbox (noexec on /tmp and /build). 19 unit tests pass.
  doCheck = false;

  meta = with lib; {
    description = "Agent-native CLI for Kagi subscribers with JSON-first search output";
    homepage = "https://github.com/Microck/kagi-cli";
    license = licenses.mit;
    maintainers = [ maintainers.ryantm ];
    platforms = platforms.linux;
  };
}

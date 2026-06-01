{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "kagi-mcp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Microck";
    repo = "kagi-mcp";
    rev = "c669f6bfb27d93f5c92299e760c4fb4ea67b3f2e";
    hash = "sha256-wCdBHpB74hdSe5Euhf7DdstEGPVtoGLB4QRJZ6kqXCU=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  # 6 integration tests spawn temp scripts from tempdir() which fails in
  # the Nix sandbox (noexec on /tmp and /build). 19 unit tests pass.
  doCheck = false;

  meta = with lib; {
    description = "Tiny MCP server built on top of kagi-cli";
    homepage = "https://github.com/Microck/kagi-mcp";
    license = licenses.mit;
    maintainers = [ maintainers.ryantm ];
    platforms = platforms.linux;
  };
}

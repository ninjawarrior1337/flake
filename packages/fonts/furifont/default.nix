{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  base,
  # Path to a base font file (or a derivation producing one),
  # e.g. ./SourceHanSansJP-Regular.otf or a nixpkgs font package.
  # A string is accepted only if it points into the Nix store
  # (e.g. pkgs.ibm-plex.sans-jp + "/share/fonts/opentype/IBMPlexSansJP-Regular.otf"),
  # which is already-pinned content and safe to use offline.
  # This is the param that selects which font gets built.
  # NOTE: a plain font *name* (e.g. "Source Han Sans JP Regular") is rejected:
  # resolving/downloading it needs network access, which the Nix sandbox blocks.
  family ? null,
  script ? null, # "hiragana" | "katakanaOn" | "hepburn"
  nf ? null, # newspaper frequency bucket, 1-48
  fontFormats ? "otf,woff2", # comma-separated: otf, woff2
  furifontConfig ? null, # path to furifont.config.json (optional)
  nodejs ? pkgs.nodejs_22,
}: let
  # Wrapper npm project whose lockfile pins the prebuilt `furifont` CLI
  # and its whole dependency closure (see furifont-cli/package-lock.json).
  cliManifest = builtins.fromJSON (builtins.readFile ./furifont-cli/package.json);

  # The CLI itself, vendored purely: dependency tarballs are prefetched via a
  # fixed-output derivation, so this build never touches the network and works
  # inside the Nix sandbox.
  furifontCli = pkgs.buildNpmPackage {
    pname = cliManifest.name;
    version = cliManifest.version;
    src = ./furifont-cli;
    npmDepsHash = "sha256-s0vqj3Z5XOZFTNdvoB8VVA/CqWzkI4E6U3vmBnRMvPw=";
    dontNpmBuild = true; # published dist/ is prebuilt; nothing to compile
    inherit nodejs;
  };

  # Interpolation (not `toString`) copies file paths into the store, so the
  # sandboxed builder sees the base font. For derivations it yields the output path.
  baseStorePath = "${base}";

  # The full CLI invocation, assembled with lib.optionals so absent options
  # vanish entirely instead of leaving blank lines inside a `\`-continued
  # shell command (a blank line ends the continuation and would split it).
  # `npx <file>` executes a local file directly with node instead of
  # resolving a package name: zero network access while still going through
  # the `npx` runner and the genuine furifont CLI entry point.
  # (--no-install is belt and braces: fail loudly instead of fetching.)
  buildCommand = lib.escapeShellArgs ([
      "npx"
      "--no-install"
      cliBin
      "build"
      "--base"
      baseStorePath
    ]
    ++ lib.optionals (family != null) ["--family" family]
    ++ lib.optionals (script != null) ["--script" script]
    ++ lib.optionals (nf != null) ["--nf" (toString nf)]
    ++ ["--formats" fontFormats "--out" "./built-fonts"]);

  # Absolute store path of the vendored CLI entry point (bit-for-bit the same
  # `bin.mjs` that `npx furifont@<version>` would fetch and execute).
  cliBin = "${furifontCli}/lib/node_modules/${cliManifest.name}/node_modules/furifont/bin.mjs";

  pname =
    if family != null
    then "furifont-${lib.strings.sanitizeDerivationName family}"
    else "furifont-font";
in
  assert lib.assertMsg (builtins.isPath base
    || lib.isDerivation base
    || lib.hasPrefix "${builtins.storeDir}/" (toString base))
  "Sandbox-compatible build: `base` must be a font file path, a derivation producing one (e.g. ./Base.otf), or a store path string — not a bare font name. Name-based lookup would require network access, which the Nix sandbox blocks.";
    pkgs.stdenv.mkDerivation {
      inherit pname;
      version = cliManifest.version;

      dontUnpack = true;

      nativeBuildInputs = [
        nodejs
        furifontCli
      ];

      # Fully sandbox-compatible: the `furifont` CLI comes from the Nix store
      # (see `furifontCli` above) and `base` is a store path, so `npx --no-install`
      # resolves everything locally and performs zero network access.
      # Build with e.g.:
      #   nix-build --arg base ./SourceHanSansJP-Regular.otf
      buildPhase = ''
        runHook preBuild

        export HOME="$TMPDIR/home"
        export npm_config_cache="$TMPDIR/npm-cache"
        mkdir -p "$HOME" "$npm_config_cache"

        # Binaries npm linked for the vendored CLI closure.
        export PATH="${furifontCli}/lib/node_modules/${cliManifest.name}/node_modules/.bin:$PATH"

        # Nix stores symlinks as symlinks, so a symlinked `base` would point at a
        # target that is not materialized in the sandbox. Fail fast with a clear
        # message instead of a cryptic ENOENT from the CLI.
        if [ -L ${lib.escapeShellArg baseStorePath} ]; then
          echo "error: base font ${lib.escapeShellArg baseStorePath} is a symlink whose target is not in the sandbox." >&2
          echo "Pass the resolved file instead (run readlink -f on it first)." >&2
          exit 1
        fi

        ${lib.optionalString (furifontConfig != null) ''
          cp ${furifontConfig} ./furifont.config.json
        ''}

        ${buildCommand}

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        # NixOS / fontconfig searches $out/share/fonts recursively.
        # Split by format so `fonts.packages` picks everything up cleanly.
        mkdir -p "$out/share/fonts/opentype" "$out/share/fonts/truetype" "$out/share/fonts/woff2"

        shopt -s nullglob
        for f in built-fonts/*.otf built-fonts/**/*.otf; do
          cp "$f" "$out/share/fonts/opentype/" 2>/dev/null || true
        done
        for f in built-fonts/*.ttf built-fonts/**/*.ttf; do
          cp "$f" "$out/share/fonts/truetype/" 2>/dev/null || true
        done
        for f in built-fonts/*.woff built-fonts/*.woff2 built-fonts/**/*.woff built-fonts/**/*.woff2; do
          cp "$f" "$out/share/fonts/woff2/" 2>/dev/null || true
        done
        shopt -u nullglob

        runHook postInstall
      '';

      meta = with lib; {
        description = "Japanese font with built-in furigana, built offline with the vendored `npx furifont` CLI";
        homepage = "https://github.com/antfu/furifont";
        license = licenses.ofl;
        platforms = platforms.all;
      };
    }

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.home) homeDirectory username;

  # systemd user services do not inherit the login shell's PATH, but T3 spawns
  # an agent CLI per provider session. Here those come from mise, so its shims
  # directory has to be on PATH explicitly.
  servicePath = lib.concatStringsSep ":" [
    "${homeDirectory}/.local/share/mise/shims"
    "${homeDirectory}/.nix-profile/bin"
    "/etc/profiles/per-user/${username}/bin"
    "/run/current-system/sw/bin"
  ];

  # Bind the server directly to the Tailnet address instead of going through
  # `tailscale serve`. The address is looked up at startup because it can
  # change if the node is re-registered; a failed lookup exits and lets systemd
  # retry, which also covers Tailscale not being up yet at boot.
  t3Serve = pkgs.writeShellScript "t3code-serve" ''
    set -euo pipefail
    host="$(${pkgs.tailscale}/bin/tailscale ip -4 | head -n 1)"
    exec ${pkgs.t3code.unwrapped}/bin/t3 serve --host "$host" "$@"
  '';
in {
  # systemd is Linux-only; shiki (darwin) would need a launchd agent instead.
  systemd.user.services.t3code = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    Unit = {
      Description = "T3 Code server";

      # Mirrors upstream's unit: stop restart-looping after 5 failures in 5
      # minutes instead of trying forever.
      StartLimitIntervalSec = 300;
      StartLimitBurst = 5;
    };

    Service = {
      Type = "simple";
      WorkingDirectory = "%h";

      Environment = [
        "T3CODE_HOME=${homeDirectory}/.t3"
        "PATH=${servicePath}"
      ];

      # Runs the flake-pinned build, so the version moves with `nix flake
      # update` rather than T3's own self-updater. The wrapper binds to the
      # Tailnet interface rather than using Tailscale Serve.
      ExecStart = "${t3Serve}";

      # Upstream settings: give the server a chance to shut down gracefully
      # before the cgroup is torn down, and keep the unit up if a provider
      # session gets OOM-killed.
      KillMode = "mixed";
      OOMPolicy = "continue";
      Restart = "always";
      RestartSec = 5;
    };

    Install.WantedBy = ["default.target"];
  };
}

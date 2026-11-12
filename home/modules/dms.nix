# Declarative wallpapers for DankMaterialShell (DMS).
#
# DMS keeps wallpapers in runtime state rather than in
# ~/.config/dms/settings.json, but its IPC can set them per output:
#
#   dms ipc call wallpaper setFor <output> <path>
#
# This module runs that command for every declared output. `setFor` also turns
# on DMS's per-monitor wallpaper mode, so no other state is touched.
#
# It runs in two places:
#   - during home-manager activation, so a rebuild in a live session applies
#     immediately;
#   - from a systemd user unit after dms.service starts, so a rebuild that is
#     only activated at boot still applies (home-manager activation runs before
#     the graphical session).
#
# The default images are tracked in dotfiles/.wallpapers and linked to
# ~/.wallpapers by the `wallpapers` dotfiles group (see
# home/modules/dotfiles.nix).
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.treelar.dms.wallpaper;

  home = config.home.homeDirectory;

  firstOutput = lib.head (lib.attrNames cfg.monitors);

  setWallpapers = lib.concatStringsSep "\n" (lib.mapAttrsToList (output: path: ''
      set_wallpaper ${lib.escapeShellArg output} ${lib.escapeShellArg path}
    '')
    cfg.monitors);

  apply = pkgs.writeShellScript "dms-wallpaper-apply" ''
    set -eu

    # The home-manager activation unit does not always inherit this.
    export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(${pkgs.coreutils}/bin/id -u)}"

    dms=${cfg.package}/bin/dms

    # No shell running (e.g. activation at boot): the login unit will do it.
    if ! "$dms" ipc call wallpaper getFor ${lib.escapeShellArg firstOutput} >/dev/null 2>&1; then
      echo "dms-wallpaper: DMS is not running, skipping" >&2
      exit 0
    fi

    set_wallpaper() {
      output="$1"
      path="$2"

      current="$("$dms" ipc call wallpaper getFor "$output" 2>/dev/null || true)"
      if [ "$current" = "$path" ]; then
        return 0
      fi

      if reply="$("$dms" ipc call wallpaper setFor "$output" "$path" 2>&1)"; then
        case "$reply" in
          SUCCESS:*) ;;
          *) echo "dms-wallpaper: $output: $reply" >&2 ;;
        esac
      else
        echo "dms-wallpaper: $output: $reply" >&2
      fi
    }

    ${setWallpapers}
  '';
in {
  options.treelar.dms.wallpaper = {
    enable = lib.mkEnableOption "declarative DankMaterialShell wallpapers";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.dux-shell;
      defaultText = lib.literalExpression "pkgs.dux-shell";
      description = "Package providing the `dms` CLI used to set wallpapers.";
    };

    monitors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        DP-4 = "${home}/.wallpapers/bafkreid7lqnirfgevjxsyneqn4q5xwh2pz33j6sq5zohtsftmnferjux4a.jpg";
        DP-5 = "${home}/.wallpapers/28196650227_bb0b3fe99c_o.jpg";
        HDMI-A-3 = "${home}/.wallpapers/29192376368_b70d7cd88b_o.jpg";
      };
      defaultText = lib.literalExpression ''
        {
          DP-4 = "''${config.home.homeDirectory}/.wallpapers/bafkreid7lqnirfgevjxsyneqn4q5xwh2pz33j6sq5zohtsftmnferjux4a.jpg";
          DP-5 = "''${config.home.homeDirectory}/.wallpapers/28196650227_bb0b3fe99c_o.jpg";
          HDMI-A-3 = "''${config.home.homeDirectory}/.wallpapers/29192376368_b70d7cd88b_o.jpg";
        }
      '';
      description = ''
        Output name (`DP-4`, `HDMI-A-3`, …) to wallpaper path. Each entry is
        applied with `dms ipc call wallpaper setFor <output> <path>`.
      '';
    };
  };

  config = lib.mkIf (cfg.enable && cfg.monitors != {}) {
    home.activation.dmsWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ${apply} || true
    '';

    systemd.user.services.dms-wallpaper = {
      Unit = {
        Description = "Apply declarative DMS wallpapers";
        After = ["dms.service"];
        # Track dms itself rather than graphical-session.target. PartOf on the
        # target plus After=dms.service created a stop-ordering cycle
        # (target -> wallpaper -> dms -> target), which made the target fail to
        # stop at logout, so the next session never started dms. Tracking dms
        # also re-applies wallpapers whenever dms restarts.
        PartOf = ["dms.service"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${apply}";
        RemainAfterExit = true;
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}

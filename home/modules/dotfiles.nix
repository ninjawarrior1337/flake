# Dotfiles live in the flake checkout and are linked into $HOME with
# out-of-store symlinks (the home-manager equivalent of `stow`).
#
# `dotfiles/` mirrors the layout of `$HOME`, so every path below is used
# verbatim inside `dotfiles/`; `.config/*` entries are linked through
# `xdg.configFile` (i.e. into `xdg.configHome`), everything else through
# `home.file` (i.e. into `$HOME`).
#
# Paths are bundled into named groups; hosts opt in with e.g.:
#
#   treelar.dotfiles.groups = ["desktop" "mise"];
{
  config,
  lib,
  ...
}: let
  # `mkOutOfStoreSymlink` needs an absolute path outside the nix store, so the
  # root must already be fully interpolated by the consumer.
  dotfiles = "${config.treelar.dotfiles.root}/dotfiles";

  # Groups of directories/files to link, relative to both `dotfiles/` and
  # `$HOME`. Add a group here, then select it from a profile.
  groups = {
    desktop = [
      ".config/niri"
      ".config/hypr"
      ".config/dms"
      ".config/vicinae"
    ];
    mise = [".config/mise"];
  };

  selected = lib.concatMap (group: groups.${group} or []) config.treelar.dotfiles.groups;
  unknownGroups = lib.filter (group: !(groups ? ${group})) config.treelar.dotfiles.groups;

  # Paths under `.config/` belong to the XDG config home: route them through
  # `xdg.configFile` so the link target follows `xdg.configHome` instead of
  # hardcoding `$HOME/.config`. Anything else stays a plain `home.file` link.
  isXdgConfig = path: lib.hasPrefix ".config/" path;
  xdgNames = map (path: lib.removePrefix ".config/" path) (lib.filter isXdgConfig selected);
  homePaths = lib.filter (path: !isXdgConfig path) selected;

  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in {
  options.treelar.dotfiles = {
    root = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.flake";
      example = "${config.home.homeDirectory}/src/flake";
      description = "Absolute path to the flake checkout containing the `dotfiles/` directory. Interpolate `config.home.homeDirectory` yourself; no `~` expansion is performed.";
    };

    groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["desktop" "mise"];
      description = "Groups of dotfiles to link into $HOME. Every entry must be a group defined in this module.";
    };
  };

  config = {
    assertions = [
      {
        assertion = unknownGroups == [];
        message = "treelar.dotfiles.groups: unknown group(s) ${lib.concatStringsSep ", " unknownGroups}; available: ${lib.concatStringsSep ", " (builtins.attrNames groups)}.";
      }
    ];

    xdg.configFile = lib.listToAttrs (map (name: {
        inherit name;
        value.source = mkLink ".config/${name}";
      })
      xdgNames);

    home.file = lib.listToAttrs (map (path: {
        name = path;
        value.source = mkLink path;
      })
      homePaths);
  };
}

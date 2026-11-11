# AGENTS.md — NixOS Configurations Guide

This repository is a **Nix flake** for managing NixOS, nix-darwin, and home-manager configurations.

## Targets

| Host            | Type          | Attribute                                    | System            |
|-----------------|---------------|----------------------------------------------|-------------------|
| `miku`          | NixOS         | `nixosConfigurations.miku`                   | `x86_64-linux`    |
| `shiki`         | nix-darwin    | `darwinConfigurations."shiki"`               | `aarch64-darwin`  |

---

## NixOS — Build, Switch, Boot

The Justfile auto-detects OS and wraps `nixos-rebuild` / `darwin-rebuild`:

```
nix-management-cmd := if os() == "macos" { "sudo darwin-rebuild" } else { "sudo nixos-rebuild" }
```

### Build only (does not activate)

```bash
just build
# Equivalent: sudo nixos-rebuild build --flake .
```

### Switch (build + activate, add to bootloader)

```bash
just switch
# Equivalent: sudo nixos-rebuild switch --flake .
```

### Boot (build + set as default boot entry, activate next boot)

```bash
just boot
# Equivalent: sudo nixos-rebuild boot --flake .
```

### Build a specific flake output directly

```bash
# Build the miku toplevel (system closure)
nix build .#nixosConfigurations.miku.config.system.build.toplevel
```

---

## nix-darwin — Build, Switch

Run these **on the Mac (shiki)**:

```bash
# Build only
sudo darwin-rebuild build --flake .

# Switch (build + activate)
sudo darwin-rebuild switch --flake .

# Rollback
sudo darwin-rebuild switch --rollback
```

---

## Flake Update

```bash
# Update all flake inputs
just update

# Full update + boot into new system
just up
```

---

## Important Notes

- **`build`, `switch`, and `boot` targets `git add .` first** — Nix flakes only see tracked files, so this is done automatically by the Justfile.
- **Dotfiles** live in `dotfiles/`, which mirrors the layout of `$HOME` (e.g. `dotfiles/.config/niri` → `~/.config/niri`). `home/modules/dotfiles.nix` defines named groups of paths and symlinks the selected ones with `mkOutOfStoreSymlink`, so edits in the checkout apply without a rebuild. Profiles opt in with `treelar.dotfiles.groups = ["desktop" "mise"];`; add new groups/paths to the `groups` attrset in that module. The checkout location defaults to `${config.home.homeDirectory}/.flake` and can be overridden with `treelar.dotfiles.root` (an absolute path; interpolate `config.home.homeDirectory` yourself).
- **Agenix secrets** are managed via [agenix](https://github.com/ryantm/agenix). Ensure secrets are decrypted before building.
- **DMS wallpapers** are declarative on `miku` via `treelar.dms.wallpaper` (`home/modules/dms.nix`). It applies `dms ipc call wallpaper setFor <output> <path>` for each declared output during activation and from a user unit after `dms.service` starts (activation alone runs before the graphical session). The images are tracked in `dotfiles/.wallpapers` and linked to `~/.wallpapers` by the `wallpapers` dotfiles group.
- **`system.autoUpgrade`** is enabled on `miku` — it auto-updates from `github:ninjawarrior1337/flake` at 3:00 AM daily with reboot window 2:00–5:00 AM.
- **`nh clean`** runs weekly on `miku` to garbage-collect old system generations (`--keep-since 4d --keep 3`).
- **Limine** is the bootloader on `miku` (`nixos/configurations/miku/limine.nix`), styled after treelar.xyz; it chainloads the Windows Boot Manager from the ESP.
- **nix-darwin on shiki** is configured to use `miku` and `maru` as remote builders (SSH, `nix.buildMachines`).
- **`nh` is installed via `home.packages`** (see `home/packages/cli.nix`) and enabled on `miku` via `programs.nh` (points at the flake checkout in the home directory).

---

## File Structure

```
Flake/
├── flake.nix                  # Main flake — all outputs defined here
├── flake.lock
├── Justfile                   # Convenience targets (build, switch, boot, update)
├── dotfiles/                  # Dotfiles, mirroring the $HOME layout
├── home/                      # Home-manager module (shared)
│   ├── nixosModule.nix        # Entry point imported by each host
│   ├── profiles/              # Per-host package sets (miku, shiki)
│   ├── modules/               # everything a profile can import:
│   │                          #   cli.nix, dms.nix, dotfiles.nix, git.nix,
│   │                          #   shell.nix, gtk-theme.nix, devtools/ (core + full),
│   │                          #   applications/ (app bundles: chrome, firefox, hacking,
│   │                          #   zed, dev, messaging, multimedia, spotify/ = plain
│   │                          #   spotify + spicetify modules and their two packages)
├── nixos/
│   ├── configurations/
│   │   ├── base.nix           # Shared NixOS module
│   │   ├── miku/              # Miku host config
│   │   │   ├── configuration.nix
│   │   │   ├── hardware-configuration.nix
│   │   │   ├── limine.nix
│   │   │   ├── nix-ld.nix
│   │   │   └── zfs.nix
│   │   └── shiki/             # Shiki (macOS) config
│   │       ├── default.nix
│   │       └── brew.nix
│   └── modules/               # Reusable NixOS modules
│       ├── darwin/
│       ├── fonts.nix
│       ├── gaming.nix
│       ├── gnome/
│       ├── hyprland/
│       ├── ime.nix
│       ├── nvidia.nix
│       ├── plasma/
│       ├── rtlsdr.nix
│       └── virtualbox.nix
├── packages/                  # Custom packages
└── scripts/                   # Misc scripts
```

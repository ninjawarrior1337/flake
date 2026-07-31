# AGENTS.md — NixOS Configurations Guide

This repository is a **Nix flake** for managing NixOS, nix-darwin, and home-manager configurations.

## Targets

| Host            | Type          | Attribute                                    | System            |
|-----------------|---------------|----------------------------------------------|-------------------|
| `miku`          | NixOS         | `nixosConfigurations.miku`                   | `x86_64-linux`    |
| `shiki`         | nix-darwin    | `darwinConfigurations."shiki"`               | `aarch64-darwin`  |
| `thisismycomputernow` | NixOS ISO | `nixosConfigurations.thisismycomputernow`     | `x86_64-linux`    |

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
# Build the miku toplevel (system closure) as a package
nix build .#packages.x86_64-linux.miku

# Build an ISO
just build_iso
# Equivalent: nix build .#images.thisismycomputernow
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
- **Agenix secrets** are managed via [agenix](https://github.com/ryantm/agenix). Ensure secrets are decrypted before building.
- **`system.autoUpgrade`** is enabled on `miku` — it auto-updates from `github:ninjawarrior1337/flake` at 3:00 AM daily with reboot window 2:00–5:00 AM.
- **`nh clean`** runs weekly on `miku` to garbage-collect old system generations (`--keep-since 4d --keep 3`).
- **Lanzaboote** is used on `miku` for Secure Boot support (`nixos/modules/lanzaboote.nix`).
- **nix-darwin on shiki** is configured to use `miku` and `maru` as remote builders (SSH, `nix.buildMachines`).
- **`nh` is installed via `home.packages`** (see `home/packages/cli.nix`) and enabled on `miku` via `programs.nh` (points at the flake checkout in the home directory).

---

## File Structure

```
Flake/
├── flake.nix                  # Main flake — all outputs defined here
├── flake.lock
├── Justfile                   # Convenience targets (build, switch, boot, update)
├── home/                      # Home-manager module (shared)
│   ├── nixosModule.nix        # Entry point imported by each host
│   ├── packages/              # cli.nix, devtools.nix, utils.nix, default.nix
│   ├── programs/              # chrome, firefox, spicetify, spotify, hacking
│   ├── profiles/              # Per-host package sets (miku, shiki, rpi-nix, thisismycomputernow)
│   ├── modules/               # gtk-theme.nix
│   ├── shell.nix
│   └── git.nix
├── nixos/
│   ├── configurations/
│   │   ├── base.nix           # Shared NixOS module
│   │   ├── miku/              # Miku host config
│   │   │   ├── configuration.nix
│   │   │   ├── hardware-configuration.nix
│   │   │   ├── nix-ld.nix
│   │   │   └── zfs.nix
│   │   ├── shiki/             # Shiki (macOS) config
│   │   │   ├── default.nix
│   │   │   └── brew.nix
│   │   ├── rpi3/              # Raspberry Pi 3 config
│   │   │   ├── default.nix
│   │   │   └── hardware-configuration.nix
│   │   └── thisismycomputernow/ # ISO installer config (default.nix)
│   └── modules/               # Reusable NixOS modules
│       ├── darwin/
│       ├── fonts.nix
│       ├── gaming.nix
│       ├── gnome/
│       ├── hyprland/
│       ├── ime.nix
│       ├── lanzaboote.nix
│       ├── nvidia.nix
│       ├── plasma/
│       ├── rtlsdr.nix
│       └── virtualbox.nix
├── packages/                  # Custom packages
└── scripts/                   # Misc scripts
```

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

All commands use **[nh](https://github.com/viperML/nh)** for a nicer UX. The Justfile auto-detects OS:

```
nix-management-cmd := if os() == "macos" { "nh darwin" } else { "nh os" }
```

### Build only (does not activate)

```bash
just build
# Equivalent: nh os build .
```

### Switch (build + activate, add to bootloader)

```bash
just switch
# Equivalent: nh os switch .
```

### Boot (build + set as default boot entry, activate next boot)

```bash
just boot
# Equivalent: nh os boot .
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
nh darwin build .

# Switch (build + activate)
nh darwin switch .

# Rollback
nh darwin switch . --rollback
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

- **Always `git add .` before building** — Nix flakes only see tracked files. The Justfile does this automatically.
- **Agenix secrets** are managed via [agenix](https://github.com/ryantm/agenix). Ensure secrets are decrypted before building.
- **`system.autoUpgrade`** is enabled on `miku` — it auto-updates from `github:ninjawarrior1337/flake` at 3:00 AM daily with reboot window 2:00–5:00 AM.
- **`nh clean`** runs weekly on `miku` to garbage-collect old system generations (`--keep-since 4d --keep 3`).
- **Lanzaboote** is used on `miku` for Secure Boot support (`nixos/modules/lanzaboote.nix`).
- **nix-darwin on shiki** is configured to use `miku` and `maru` as remote builders (SSH).

---

## File Structure

```
Flake/
├── flake.nix                  # Main flake — all outputs defined here
├── flake.lock
├── Justfile                   # Convenience targets (build, switch, boot, update)
├── home/                      # Home-manager module (shared)
│   └── nixosModule.nix
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
│   │   └── thisismycomputernow/ # ISO installer config
│   └── modules/               # Reusable NixOS modules
│       ├── gaming.nix
│       ├── hyprland/
│       ├── ime.nix
│       ├── lanzaboote.nix
│       ├── nvidia.nix
│       └── ...
├── packages/                  # Custom packages
└── scripts/                   # Misc scripts
```

nix-management-cmd := if os() == "macos" { "sudo darwin-rebuild" } else { "sudo nixos-rebuild" }

switch:
    git add .
    {{ nix-management-cmd }} switch --flake .

boot:
    git add .
    {{ nix-management-cmd }} boot --flake .

build:
    git add .
    {{ nix-management-cmd }} build --flake .

update-helium:
    nix run .#update-helium

update: update-helium
    nix flake update

up: update boot

build_iso:
    git add .
    nix build .#images.thisismycomputernow

nix-management-cmd := if os() == "macos" { "nh darwin" } else { "nh os" }

switch:
    git add .
    {{ nix-management-cmd }} switch .

boot:
    git add .
    {{ nix-management-cmd }} boot .

build:
    git add .
    {{ nix-management-cmd }} build .

update-helium:
    nix run .#update-helium

update: update-helium
    nix flake update

up: update boot

build_iso:
    git add .
    nix build .#images.thisismycomputernow

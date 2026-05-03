nix-management-cmd := if os() == "macos" {"nh darwin"} else {"nh os"}

switch:
    git add .
    sudo {{nix-management-cmd}} switch .

boot:
    git add .
    sudo {{nix-management-cmd}} boot .

update-helium:
    nix run .#update-helium

update: update-helium
    nix flake update

up: update boot

build_iso:
    git add .
    nix build .#images.thisismycomputernow

nix-management-cmd := if os() == "macos" {"darwin-rebuild"} else {"nixos-rebuild"}

switch:
    git add .
    sudo {{nix-management-cmd}} --flake .# switch

boot:
    git add .
    sudo {{nix-management-cmd}} --flake .# boot

update-helium:
    nix run .#update-helium

update: update-helium
    nix flake update

up: update boot

build_iso:
    git add .
    nix build .#images.thisismycomputernow
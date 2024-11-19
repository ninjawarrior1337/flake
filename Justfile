switch:
    git add .
    sudo nixos-rebuild --flake .# switch

boot:
    git add .
    sudo nixos-rebuild --flake .# boot

update:
    nix flake update

up: update boot

build_iso:
    git add .
    nix build .#images.thisismycomputernow
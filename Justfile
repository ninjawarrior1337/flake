switch:
    git add .
    sudo nixos-rebuild --flake .# switch

update:
    nix flake update

up: update switch

build_iso:
    git add .
    nix build .#images.thisismycomputernow
switch:
    git add .
    sudo nixos-rebuild --flake .# switch

build_iso:
    git add .
    nix build .#images.thisismycomputernow
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

# Update flake inputs + helium, build the current system, then commit and push only if the build succeeds
auto-update: update
    git add .
    @if {{ nix-management-cmd }} build --flake .; then \
        git add .; \
        if git diff --cached --quiet; then \
            echo "nothing to commit"; \
        else \
            git commit -m "flake: update inputs"; \
        fi; \
        git push; \
    else \
        echo "build failed - nothing committed or pushed"; \
        exit 1; \
    fi

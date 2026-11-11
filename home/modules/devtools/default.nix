# `imports = [../modules/devtools]` gives the full set; use `./core.nix` or
# `./full.nix` explicitly when a host needs a specific subset.
_: {
  imports = [./full.nix];
}

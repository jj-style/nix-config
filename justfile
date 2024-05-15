export NIX_CONFIG := "experimental-features = nix-command flakes"

_default:
    just --list

# format all nix files
fmt:
    fd -e nix -X nixfmt {}

# rebuild system configuration for the given host 
system hostname:
    sudo nixos-rebuild switch --flake .#{{hostname}}

# rebuild home configuration for the given user and host
home username hostname:
    home-manager switch --flake .#{{username}}@{{hostname}}
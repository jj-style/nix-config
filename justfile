export NIX_CONFIG := "experimental-features = nix-command flakes"

_default:
    just --list

system hostname:
    sudo nixos-rebuild switch --flake .#{{hostname}}

home username hostname:
    home-manager switch --flake .#{{username}}@{{hostname}}
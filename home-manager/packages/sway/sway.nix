{ config, pkgs, ... }:

# TODO(jj): figure out using sway with home-manager (https://wiki.nixos.org/wiki/Sway#Using_Home_Manager)
# on a non-nix system

{
  home.packages = with pkgs; [ ];
  home.file = {
    ".config/sway/config".source = ./config;
  };
}

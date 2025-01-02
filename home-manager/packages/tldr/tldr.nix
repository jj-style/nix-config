{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ tealdeer ];
  home.file = {
    ".config/tealdeer/config.toml".source = ./config.toml;
  };
}

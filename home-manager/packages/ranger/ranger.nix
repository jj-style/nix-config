{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ ranger ];
  home.file = {
    ".config/ranger/commands.py".source = ./commands.py;
    ".config/ranger/rc.conf".source = ./rc.conf;
    ".config/ranger/rifle.conf".source = ./rifle.conf;
  };
}

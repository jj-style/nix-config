{ config, pkgs, ... }: {
  home.packages = with pkgs; [ alacritty alacritty-theme];

  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
}

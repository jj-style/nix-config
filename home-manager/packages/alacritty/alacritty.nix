{ config, pkgs, ... }: {
  home.packages = with pkgs; [ alacritty alacritty-theme ];

  xdg.configFile."alacritty/alacritty.toml".source = ./alacritty.toml;
}

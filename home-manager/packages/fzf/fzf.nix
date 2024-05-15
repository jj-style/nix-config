{ config, pkgs, ... }: {
  home.packages = with pkgs; [ fzf ];

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}

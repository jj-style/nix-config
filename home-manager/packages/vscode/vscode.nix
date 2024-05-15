{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    vscodium.fhs
  ];

  xdg.configFile."VSCodium/User/settings.json".source = ./settings.json;

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };
}

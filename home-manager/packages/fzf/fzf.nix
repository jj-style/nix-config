{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    fzf
    ripgrep
  ];

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "rg --files";
  };
}

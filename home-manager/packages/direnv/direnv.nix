{ config, pkgs, ... }: {
  home.packages = with pkgs; [ direnv ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
}

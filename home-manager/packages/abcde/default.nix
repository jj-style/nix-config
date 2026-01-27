{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    abcde
  ];

  home.file.".abcde.conf".source = ./abcde.conf;
}

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ zenith ];
}

{lib, pkgs, config, ...}:
{
  imports = [
    ./homepage
    ./open-webui
    ./microbin
    ./stirling-pdf
  ];
}

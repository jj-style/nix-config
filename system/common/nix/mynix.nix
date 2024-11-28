{ lib, pkgs, config, ... }:
with lib;
let 
    cfg = config.services.mynix;
in {

  options.services.mynix = {
    enable = mkEnableOption "nix stuff";
    enableGc = mkEnableOption "enable garbage collection";
    enableStoreOptimise = mkEnableOption "enable store optimise";
    enableAutoUpgrade = mkEnableOption "enable auto upgrade";
  };

  config = mkIf cfg.enable {
    # Garbage collect
    nix.gc = {
      automatic = cfg.enableGc;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };   

    nix.optimise = {
      automatic = cfg.enableStoreOptimise;
      dates = [ "03:45" ];
    };

    system.autoUpgrade = {
      enable = cfg.enableAutoUpgrade;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
  };
}
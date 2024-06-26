{ lib, pkgs, config, ... }:
with lib;                      
let
  # Shorter name to access final settings a 
  # user of docker.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.docker;
in {
  # Declare what settings a user of this "docker.nix" module CAN SET.
  options.services.docker = {
    enable = mkEnableOption "docker service";
    dockerUsers = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "docker.nix" module ENABLED this module 
  # by setting "services.docker.enable = true;".
  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = cfg.dockerUsers;
  };
}
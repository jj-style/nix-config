
{lib, pkgs, config, ...}:
{

  sops.secrets."microbin/env" = {};

  services.microbin = {
    enable = true;
    dataDir = "/mnt/tank/app-data/microbin";
    settings = {
      MICROBIN_PORT=8400;
      MICROBIN_DISABLE_TELEMETRY=true;
      MICROBIN_TITLE="pastebin";
      MICROBIN_HIDE_LOGO=true;
      MICROBIN_HIDE_FOOTER=true;
      MICROBIN_LIST_SERVER=false;
      MICROBIN_HIGHLIGHTSYNTAX=true;

      MICROBIN_EDITABLE=true;
      MICROBIN_ENABLE_READONLY=true;
      MICROBIN_QR=true;
      MICROBIN_PRIVATE=true;
      MICROBIN_SHOW_READ_STATS=false;
      MICROBIN_ENABLE_BURN_AFTER=false;
      MICROBIN_ETERNAL_PASTA=false;
    };
    passwordFile = "${config.sops.secrets."microbin/env".path}";
  };

  systemd.services.microbin.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "${config.users.users.microbin.name}";
    Group = "${config.users.groups.microbin.name}";
  };
  users.users.microbin = {
    group = "microbin";
    isSystemUser = true;
  };
  users.groups.microbin = { };
}

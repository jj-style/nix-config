
{lib, pkgs, config, ...}:
{
  sops.secrets."stirling-pdf/env" = {};

  services.stirling-pdf = {
    enable = true;
    package = pkgs.unstable.stirling-pdf;
    environment = {
      SERVER_PORT = 48380;
      LANGS = "en_GB";
      SYSTEM_DEFAULTLOCALE = "en-GB";
      SYSTEM_ENABLEANALYTICS = "false";
    };
    environmentFiles = [
      "${config.sops.secrets."stirling-pdf/env".path}"
    ];
  };

  systemd.services.stirling-pdf.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "${config.users.users.stirling-pdf.name}";
    Group = "${config.users.groups.stirling-pdf.name}";
  };
  users.users.stirling-pdf = {
    group = "stirling-pdf";
    isSystemUser = true;
  };
  users.groups.stirling-pdf = { };
}

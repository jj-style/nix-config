
{lib, pkgs, config, ...}:
{

  sops.secrets."open-webui/env" = {
    mode = "0444";
  };

  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 24087;
    openFirewall = false;
    environmentFile = "${config.sops.secrets."open-webui/env".path}";
    environment = {
        SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
        REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
    };
  };
}


{lib, pkgs, config, ...}:
{

  sops.secrets."homepage/env" = {};

  services.homepage-dashboard = {
    enable = true;
    openFirewall = false;
    listenPort = 1111;
    docker = {
      mydocker = {
        socket = "/var/run/docker.sock";
      };
    };
    environmentFile = "${config.sops.secrets."homepage/env".path}";
    settings = {
      title = "homelab";
      statusStyle = "dot";
      headerStyle = "clean";
      layout = {
        "Media" = {
          style = "row";
          columns = 4;
          useEqualHeights = true;
        };
        "Tools" = {
          style = "row";
          columns = 4;
          useEqualHeights = true;
        };
        "Admin" = {
          style = "row";
          columns = 4;
          useEqualHeights = true;
        };
      };
    };
    bookmarks = [
      {
        Selfhosted = [
          {
            linuxserver = [
              {
                abbr = "LSIO";
                href = "https://fleet.linuxserver.io/";
              }
            ];
          }
          {
            "selfh.st" = [
              {
                abbr = "SH";
                href = "https://selfh.st/apps/";
              }
            ];
          }
          {
            awesome-selfhosted = [
              {
                abbr = "AWSM";
                href = "https://github.com/awesome-selfhosted/awesome-selfhosted";
              }
            ];
          }
        ];
      }
    ];
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
          uptime = true;
        };
      }
      {
        resources = {
          label = "storage";
          disk = "/mnt/storage";
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
      {
        openmeteo = {
          label = "London";
          latitude = 51.507351;
          longitude = -0.127758;
          timezone = "Europe/London";
          units = "metric";
          cache = 5;
          format = {
            maximumFractionDigits = 1;
          };
        };
      }
    ];
  };

  systemd.services.homepage-dashboard.serviceConfig.Group = "docker";
}

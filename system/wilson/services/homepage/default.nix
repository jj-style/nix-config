
{lib, pkgs, config, ...}:
{

  sops.secrets."homepage/env" = {};
  sops.secrets."homepage/it-tools-url" = {};
  sops.secrets."homepage/open-webui-url" = {};

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

  sops.templates."homepage-services.yaml" = {
    content = ''
      - Tools:
        - it-tools:
            href: "${config.sops.placeholder."homepage/it-tools-url"}"
            siteMonitor: "${config.sops.placeholder."homepage/it-tools-url"}"
            description: IT tools
            icon: sh-it-tools
        - open-webui:
            href: "${config.sops.placeholder."homepage/open-webui-url"}"
            siteMonitor: "${config.sops.placeholder."homepage/open-webui-url"}"
            description: Open WebUI
            icon: sh-open-webui
    '';
    #owner = config.systemd.services.homepage-dashboard.serviceConfig.User;
    mode = "0440";
    group = "docker";
  };

  environment.etc."homepage-dashboard/services.yaml".source = lib.mkForce "${config.sops.templates."homepage-services.yaml".path}";
}

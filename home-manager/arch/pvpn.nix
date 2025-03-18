# creates a script which when not connected to my desired home SSID which has a VPN
# active on the whole network, starts protonvpn and a killswitch

{ config, pkgs, ... }: {
  sops = {
    secrets = {
      "ssid_with_vpn" = {};
    };
    templates = {
      # script for the newer pvpn cli which seems to have disappeared
      "pvpn_autostart_old".content = ''
        #!/bin/bash
        ACTIVE_SSID=$(nmcli -t -f active,ssid dev wifi | /bin/grep -E '^yes' | cut -d ':' -f2 | tr -d '[:space:]')

        sleep .75 # give nm time to connect and start
        protonvpn-cli ks --off
        sleep .2
        protonvpn-cli d
        sleep .2
        if [[ "$ACTIVE_SSID" == "${config.sops.placeholder.ssid_with_vpn}" ]]; then
            exit 0;
        fi
        protonvpn-cli ks --on
        sleep .2
        protonvpn-cli c -f
      '';
      # this is for the older community pvpn cli client
      "pvpn_autostart".content = ''
        #!/bin/bash
        ACTIVE_SSID=$(nmcli -t -f active,ssid dev wifi | /bin/grep -E '^yes' | cut -d ':' -f2 | tr -d '[:space:]')

        sleep .75 # give nm time to connect and start
        sleep .2
        sudo protonvpn d
        sleep .2
        if [[ "$ACTIVE_SSID" == "${config.sops.placeholder.ssid_with_vpn}" ]]; then
            exit 0;
        fi
        sleep .2
        sudo protonvpn c -f
      '';
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "pvpn_autostart_nix"
      (builtins.readFile "${config.sops.templates."pvpn_autostart".path}"))
  ];
}

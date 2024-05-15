{ inputs, lib, config, pkgs, ... }:
let
in {
  # ========== SYSTEMD ========== #
  environment.etc = {
    "wallpapers/default.jpg".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/pop-os/wallpapers/03a25a14a76eaf3825b980ab50aad6698c1c5a35/original/jasper-van-der-meij-97274-edit.jpg";
        sha256 = "sha256:10lcr3r9bs3j4s19wps2gkxr6ay7ly59aadkkdd0122x9kywk2r9";
    };
  };

  systemd.user.services.reset-wallpaper-user = {
    enable = true;
    after = [ "default.target" ];
    wantedBy = [ "default.target" ];
    description = "Reset wallpaper to default";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      StandardOutput = "journal";
      ExecStart = "-${
          pkgs.writeShellScript "reset-wallpaper-user" ''
            #!/run/current-system/sw/bin/bash
            for picUriMode in picture-uri picture-uri-dark; do
              ${pkgs.glib}/bin/gsettings set org.gnome.desktop.background $picUriMode 'file:///etc/wallpapers/default.jpg';
            done
          ''
        }";
      ExecStop = "-${
          pkgs.writeShellScript "reset-wallpaper-user" ''
            #!/run/current-system/sw/bin/bash
            for picUriMode in picture-uri picture-uri-dark; do
              ${pkgs.glib}/bin/gsettings set org.gnome.desktop.background $picUriMode 'file:///etc/wallpapers/default.jpg';
            done
          ''
        }";
    };
  };

  systemd.services.reset-wallpaper = {
    enable = true;
    after = [ "suspend.target" "hibernate.target" "sleep.target" ];
    before = [ "poweroff.target" "reboot.target" ];
    wantedBy = [
      "suspend.target"
      "hibernate.target"
      "sleep.target"
      "poweroff.target"
      "reboot.target"
    ];
    description = "Reset wallpaper to default";
    serviceConfig = {
      User = "jj";
      ExecStart = "-${
          pkgs.writeShellScript "reset-wallpaper" ''
            	#!/run/current-system/sw/bin/bash
                    source /etc/set-environment
            	export DISPLAY=:0
            	export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/`id -u jj`/bus
                    for picUriMode in picture-uri picture-uri-dark; do
                      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.background $picUriMode 'file:///etc/wallpapers/default.jpg';
                    done
          ''
        }";
    };
  };
}

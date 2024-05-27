{ config, lib, pkgs, ... }: {
  home.packages = with pkgs;
    [ pop-launcher ] ++ (with pkgs.gnomeExtensions; [
      pop-shell
      clipboard-indicator
      weather-or-not
      places-status-indicator
    ]);

  # gnome dconf settings
  dconf = {
    enable = true;
    settings = {
      # ui settings
      "org/gnome/desktop/interface" = {
        clock-show-seconds = false;
        clock-show-weekday = true;
        color-scheme = "prefer-dark";
        enable-hot-corners = true;
        font-antialiasing = "grayscale";
        font-hinting = "slight";
        gtk-theme = "Nordic";
        toolkit-accessibility = true;
      };

      # night light
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = true;
        night-light-temperature = lib.hm.gvariant.mkUint32 3300;
      };

      # custom gnome keyboard shortcuts
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Shift><Super>q" ];

        # disable these so don't collide with pop-shell
        toggle-maximized = [ "<Super>f" ];
        unmaximize = [ ];
        maximize = [ ];
        minimize = [ "<Control><Super>m" ];
        move-to-monitor-left = [ ];
        move-to-monitor-right = [ ];
        toggle-tiled-left = [ "<Control><Super>Left" ];
        toggle-tiled-right = [ "<Control><Super>Right" ];
        toggle-message-tray = [ ];

        switch-to-workspace-left = [ "<Super>Page_Up" ];
        switch-to-workspace-right = [ "<Super>Page_Down" ];
        move-to-workspace-left = [ "<Shift><Super>Page_Up" ];
        move-to-workspace-right = [ "<Shift><Super>Page_Down" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
        {
          name = "open terminal";
          command = "alacritty";
          binding = "<Super>Return";
        };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
        {
          name = "open file explorer";
          command = "nautilus";
          binding = "<Super>e";
        };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
        {
          name = "open firefox";
          command = "firefox";
          binding = "<Super>b";
        };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" =
        {
          name = "open librewolf";
          command = "librewolf";
          binding = "<Shift><Super>b";
        };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" =
        {
          name = "previous wallpaper";
          command = "wallpaper.sh prev";
          binding = "<Shift><Control><Super>comma";
        };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" =
        {
          name = "next wallpaper";
          command = "wallpaper.sh next";
          binding = "<Shift><Control><Super>period";
        };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" =
        {
          name = "reset wallpaper";
          command = "wallpaper.sh";
          binding = "<Shift><Control><Super>Home";
        };

      # window settings
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        num-workspaces = 10;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
      };

      # enable gnome extensions
      "org/gnome/shell" = {
        favorite-apps = [
          "firefox.desktop"
          "Alacritty.desktop"
          "org.gnome.Nautilus.desktop"
          "codium.desktop"
          "signal-desktop.desktop"
        ];

        disabled-user-extensions = false;
        enabled-extensions = [
          "pop-shell@system76.com"
          "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
          "clipboard-indicator@tudmotu.com"
          "weatherornot@somepaulo.github.io"
          "places-menu@gnome-shell-extensions.gcampax.github.com"
        ];
      };

      # pop-shell extension config
      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = false;
        tile-enter = [ "<Shift><Super>Return" ];
      };

      # weatherornot extension config
      "org/gnome/shell/extensions/weatherornot" = { position = "right"; };
    };
  };
}

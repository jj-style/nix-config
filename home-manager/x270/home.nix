# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, lib, config, pkgs, ... }:
let
  username = "jj";
  homeDirectory = "/home/jj";
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    inputs.sops-nix.homeManagerModules.sops

    ../packages/cli.nix
    ../packages/dev.nix
    ../packages/alacritty/alacritty.nix
    ./gnome.nix

  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = username;
    homeDirectory = homeDirectory;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    fontconfig
    powerline-fonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    nixfmt-classic

    # desktop apps
    firefox
    librewolf
    thunderbird
    bitwarden
    bitwarden-cli
    signal-desktop
    jellyfin-media-player
    vlc
    shotwell

    (pkgs.writeShellScriptBin "wallpaper.sh"
      (builtins.readFile scripts/wallpaper.sh))
  ];

  # required to autoload fonts from packages installed via Home Manager
  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # sops secrets
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "${homeDirectory}/.age-key.txt";
    age.generateKey = true;

    secrets = {
      "ssh/public" = {
        path = "${homeDirectory}/.ssh/id_ed25519.pub";
        mode = "0644";
      };
      "ssh/private" = {
        path = "${homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jj/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { EDITOR = "vim"; };

  # Set shell aliases
  home.shellAliases = {
    cat = "bat";
    find = "fd";
    grep = "rg";
    diff = "delta";
  };

  # Enable home-manager
  programs = { home-manager.enable = true; };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

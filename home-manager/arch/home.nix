{ config, pkgs, ... }:
let 
  homeDir = "/home/jj";
in {
  home.username = "jj";
  home.homeDirectory = homeDir;

  imports = [
    <sops-nix/modules/home-manager/sops.nix>
    ../packages/bash/bash.nix
    ../packages/tmux/tmux.nix
    ../packages/git/git.nix
    ../packages/tree/tree.nix
    ../packages/just/just.nix
    ../packages/starship/starship.nix
    ../packages/direnv/direnv.nix
    ../packages/ranger/ranger.nix
    ../packages/fzf/fzf.nix
    ../packages/htop/htop.nix
    ../packages/zenith/zenith.nix
    ../packages/tldr/tldr.nix
    ../packages/sway/sway.nix
    # using wireguard config until protonvpn sort themselves out on linux
    # ./pvpn.nix
  ];

  sops = {
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
  };


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    fd
    ripgrep
    bat
    duf
    dua
    jq
    sftpman
  ];

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

    ".Xresources".source = ../dotfiles/Xresources;
    ".Xdefaults".source = ../dotfiles/Xresources;
    ".inputrc".source = ../dotfiles/inputrc;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jj/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "vim";
    WWW_HOME = "https://html.duckduckgo.com/html/";
    PAGER = "bat";
  };
  
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
  ];
  
  home.shellAliases = {
    home = "cd ~";
    
    dcu = "docker compose up -d";
    dcd = "docker compose down";

    ga = "git add .";
		gb = "git branch";
		gc = "git commit -m";
		gcl = "git clone";
		gmg = "git merge";
		gcm = "git checkout master";
		gco = "git checkout";
		gcb = "git checkout -b";
		gd = "git diff";
		gf = "git fetch";
		gi = "git init";
		gl = "git log --pretty --oneline --abbrev-commit --graph --color";
		gp = "git push origin \$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)";
		gpl = "git pull";
		gss = "git status";
		gx = "git add . && git commit -m";
		prune = "git branch --merged master | grep -v master | xargs -n 1 git branch -d";
		stash = "git stash";
		pop = "git stash pop";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

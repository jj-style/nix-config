{ config, pkgs, ... }:
let
  tmux-themepack = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "themepack";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "jimeh";
      repo = "tmux-themepack";
      rev = "7c59902f64dcd7ea356e891274b21144d1ea5948";
      sha256 = "sha256-c5EGBrKcrqHWTKpCEhxYfxPeERFrbTuDfcQhsUAbic4=";
    };
  };
in {
  home.packages = with pkgs; [ git ];

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 100000;
    clock24 = true;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.tmux-fzf
      tmuxPlugins.yank
      #{
      #  plugin = tmuxPlugins.power-theme;
      #  extraConfig = ''
      #    set -g @tmux_power_theme 'moon'
      #  '';
      #}
      {
        plugin = tmux-themepack;
        extraConfig = ''
          set -g @themepack 'powerline/default/purple'
        '';
      }
    ];
    shortcut = "a";
    extraConfig = ''
      # remove pre-bound shortcuts
      # unbind-key -T copy-mode -a
      # unbind-key -T copy-mode-vi -a
      # unbind-key -T prefix -a
      unbind-key -T root -a

      # sane split commands
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Mouse works as expected
      set-option -g mouse on

      # moving between windows with vim movements
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      # moving between windows with vim movement keys
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # resize panes with vim movement keys
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      # move windows left/right with Crl-j/k 
      bind -r C-j swap-window -t -1\; select-window -t -1
      bind -r C-k swap-window -t +1\; select-window -t +1

    '';
  };
}

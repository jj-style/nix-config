{ config, pkgs, ... }: {
  imports = [
    ./vim/vim.nix
    ./tmux/tmux.nix
    ./git/git.nix
    ./fzf/fzf.nix
    ./bash/bash.nix
    ./tree/tree.nix
    ./just/just.nix
    ./make/make.nix
    ./starship/starship.nix
    ./direnv/direnv.nix
  ];

  home.packages = with pkgs; [
    ranger
    wget
    fd
    ripgrep
    bat
    delta
    duf
    dua
    jq
    tealdeer
  ];
}

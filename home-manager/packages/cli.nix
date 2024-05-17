{ config, pkgs, ... }: {
    imports = [
    ../packages/vim/vim.nix
    ../packages/tmux/tmux.nix
    ../packages/git/git.nix
    ../packages/fzf/fzf.nix
    ../packages/bash/bash.nix
    ../packages/tree/tree.nix
    ../packages/just/just.nix
    ../packages/starship/starship.nix
    ../packages/direnv/direnv.nix
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
    ];
}

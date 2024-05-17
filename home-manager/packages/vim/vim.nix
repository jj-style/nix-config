{ config, pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ 
        vim-airline
    ];
    settings = {
        ignorecase = true;
        smartcase = true;
        
        number = true;
        relativenumber = true;

        expandtab = true;
        shiftwidth = 4;
        tabstop = 4;

        modeline = true;
        mouse = "a";

    };
    defaultEditor = true;
    extraConfig = ''
    '';
  };
}

{ config, pkgs, ... }: {
  imports = [ ./vscode/vscode.nix ];

  home.packages = with pkgs; [
    go
    gopls
    gotools
    nodejs
    python312
    python312Packages.jedi
    python312Packages.jedi-language-server
    pre-commit
    convco
  ];

  programs.bash.initExtra = ''
    PATH="$PATH:~/go/bin"
  '';

  # host/home specific program config
  programs.vim = {
    plugins = with pkgs.vimPlugins; [ vim-go coc-nvim coc-go jedi-vim ];
    extraConfig = ''
      ${(builtins.readFile ./vim/plug-config/vim-go.vim)}
      ${(builtins.readFile ./vim/plug-config/coc.vim)}
    '';
  };

}

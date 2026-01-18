{ config, pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-fugitive
      fzf-vim
      vim-lastplace
      nerdcommenter
      nerdtree
      #gruvbox
      emmet-vim
      ultisnips
      vim-gitgutter
      vim-surround
      vim-test
      vim-easy-align
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
      " set leader to ,
      let mapleader=","

      " enable filetype plugin
      filetype plugin on

      " clear highlighting
      nnoremap <silent> <leader><space> :nohlsearch<CR>

      " split windows
      nnoremap sh :split<Return><C-w>W
      nnoremap sv :vsplit<Return><C-w>W
      nnoremap sx :close<Return><C-w>W

      " basically grep
      nmap // :BLines<CR>
      " search across directory
      nmap ?? :Rg<CR>
      " search for files
      nmap <leader>f :Files<CR>

      " vim-airline
      let g:airline_theme = 'violet'
      let g:airline_powerline_fonts=1

      " nerdtree
      nnoremap <leader>nt :NERDTreeToggle<CR>
      nnoremap <silent> <C-t> :NERDTreeToggle %<CR>
      nnoremap <leader>ntf :NERDTreeFind<CR>

      " transparent
      autocmd vimenter * ++nested hi Normal guibg=NONE ctermbg=NONE

      " set cwd when open file
      " https://superuser.com/a/195191
      " autocmd BufEnter * lcd %:p:h

      " colorscheme gruvbox
      " set background=dark

      " 80 char guide
      set colorcolumn=80

      let g:UltiSnipsExpandTrigger = "<nop>"
    '';
  };
}

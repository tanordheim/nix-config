{ config, lib, ... }:
with lib;
let
  cfg = config.jetbrains;

  indent =
    spaces: text:
    lib.concatStringsSep "\n" (
      map (line: if line == "" then "" else spaces + line) (lib.splitString "\n" text)
    );

  baseConfig = ''
    " use space as the leader key
    let mapleader=" "

    " general settings
    set number " show line numbers
    set ignorecase " ignore case when searching
    set smartcase " case sensitive search if the search term is not all lower case
    set scrolloff=15  " minimum number of lines to show above/below the current line
    set sidescrolloff=3 " minimum number of columns to show to the left/right of the current column
    set clipboard=unnamedplus,unnamed,ideaput " use system clipboard
    set matchpairs=(:),{:},[:],<:> " characters that form pairs, can be jumped between using %

    " temporarily disabled due to slowdowns in ideavim
    " set nohlsearch
    " set noincsearch
    set hlsearch " highlight all matches
    set incsearch " show matches as you type

    " make ideavim act more like neovim
    " from https://gist.github.com/mikeslattery/d2f2562e5bbaa7ef036cf9f5a13deff5
    set backspace=indent,eol,start
    set formatoptions=tcqj
    set listchars=tab:>\ ,trail:-,nbsp:+
    set shortmess=filnxtToOF

    " gcc and gc<action> mappings.
    Plug 'tpope/vim-commentary'
    " s action, such as cs"' (replace " with '), ds" (unquote)
    Plug 'tpope/vim-surround'
    " enable which-key (must be installed from Marketplace)
    set which-key
    " enable extended matching (default in neovim)
    set matchit
    " highlight yanked text
    Plug 'machakann/vim-highlightedyank'

    " quick navigation between open buffers
    nnoremap <C-Left> <C-w>h
    nnoremap <C-Right> <C-w>l
    nnoremap <C-Down> <C-w>j
    nnoremap <C-Up> <C-w>k

    " managing buffers and navigating code
    nnoremap <leader>bd :action CloseContent<CR>
    nnoremap <leader>bD :action CloseAllEditors<CR>
    nnoremap [d :action GotoPreviousError<CR>
    nnoremap ]d :action GotoNextError<CR>
    nnoremap [[ :action MethodUp<CR>
    nnoremap ]] :action MethodDown<CR>
    nnoremap <leader>sf :action SearchEverywhere<CR>
    nnoremap <leader>sg :action FindInPath<CR>
    nnoremap <leader>xx :action ActivateProblemsViewToolWindow<CR>
    nnoremap <C-i> :action ActivateTerminalToolWindow<CR>
    nnoremap <TAB> :action NextTab<CR>
    nnoremap <S-TAB> :action PreviousTab<CR>

    " lsp actions
    nnoremap gd :action GotoDeclaration<CR>
    nnoremap gi :action GotoImplementation<CR>
    nnoremap gr :action FindUsages<CR>
    nnoremap <leader>ws :action GotoSymbol<CR>
    nnoremap <C-k> :action ParameterInfo<CR>
    nnoremap <leader>rn :action RenameElement<CR>
    nnoremap <leader>ca :action ShowIntentionActions<CR>

    " edit and reload the ideavim config
    nnoremap <leader>vv :e ~/.config/ideavim/ideavimrc<CR>
    nnoremap <leader>vr :source ~/.config/ideavim/ideavimrc<CR>

    " clear search highlight
    nnoremap <Esc> :nohls<CR>
  '';

  # Generate conditional blocks for each product
  productConfigs = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (product: configText: ''
      if &ide =~? '${product}'
      ${configText}
      endif
    '') cfg.ideavimConfigs
  );

  fullConfig =
    baseConfig
    + lib.optionalString (cfg.ideavimConfigs != { }) ''

      " Product-specific configurations
      if has('ide')
      ${productConfigs}
      endif
    '';
in
{
  options.jetbrains.ideavimConfigs = lib.mkOption {
    type = types.attrsOf types.lines;
    default = { };
    description = "Product-specific IdeaVim configurations keyed by product name (e.g., 'rider', 'pycharm').";
  };

  config = {
    home-manager.users.${config.username}.xdg.configFile."ideavim/ideavimrc".text = fullConfig;
  };
}

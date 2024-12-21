{ config, ... }:
{
  home-manager.users.${config.username}.xdg.configFile.ideaVimConfig = {
    target = "ideavim/ideavimrc";
    text = ''
      "
      " general settings
      "

      " use space as the leader key
      let mapleader=" "

      set number " show line numbers
      set hlsearch " highlight all matches
      set ignorecase " ignore case when searching
      set smartcase " case sensitive search if the search term is not all lower case
      " set incsearch " show matches as you type
      set scrolloff=15  " minimum number of lines to show above/below the current line
      set sidescrolloff=3 " minimum number of columns to show to the left/right of the current column
      set clipboard=unnamedplus,unnamed,ideaput " use system clipboard
      set matchpairs=(:),{:},[:],<:> " characters that form pairs, can be jumped between using %

      "
      " mappings
      "
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l
      nnoremap gd :action GotoDeclaration<CR>
      nnoremap gD :action GotoTypeDeclaration<CR>
      noremap K :action ParameterInfo<CR>
      nnoremap gi :action GotoImplementation<CR>
      noremap gr :action FindUsages<CR>
      nnoremap <leader>cr :action RenameElement<CR>
      nnoremap <leader>ca :action ShowIntentionActions<CR>
      nnoremap [d :action GotoPreviousError<CR>
      nnoremap ]d :action GotoNextError<CR>
      nnoremap [D :action ReSharperGotoNextErrorInSolution<CR>
      nnoremap ]D :action ReSharperGotoPrevErrorInSolution<CR>
      nnoremap [[ :action MethodUp<CR>
      nnoremap ]] :action MethodDown<CR>
      nnoremap <leader>sf :action SearchEverywhere<CR>
      nnoremap <leader>/ :action FindInPath<CR>

      " edit and reload the ideavim config
      nnoremap <leader>vv :e ~/.ideavimrc<CR>
      nnoremap <leader>vr :source ~/.ideavimrc<CR>

      " testing
      nnoremap <leader>tt :action RiderUnitTestRunContextAction<CR>
      nnoremap <leader>ta :action RunAllTestsInCurrentFile<CR>
      nnoremap <leader>tl :action RiderUnitTestRepeatPreviousRunAction<CR>

      " tool/window navigation
      nnoremap <C-i> :action ActivateTerminalToolWindow<CR>
      nnoremap <TAB> :action NextTab<CR>
      nnoremap <S-TAB> :action PreviousTab<CR>
      nnoremap <leader>x :action CloseContent<CR>
      nnoremap <leader>X :action CloseAllEditors<CR>

      " refactoring

      " clear search highlight
      nnoremap <Esc> :nohls<CR>

      " emulate NERDTree
      set NERDTree
      let NERDTreeQuitOnOpen=1
      " nnoremap <C-n> :NERDTreeToggle<CR>

      " emulate commentary
      set commentary

      " highlight yanked text
      set highlightedyank

      " enable easymotion
      "set easymotion

      " enable vim-surround
      set surround
    '';
  };
}

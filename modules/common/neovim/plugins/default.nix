{ ... }:
{
  imports = [
    # needs to be loaded early
    ./snacks.nix

    ./blink-cmp.nix
    ./conform.nix
    ./lsp.nix
    ./lualine.nix
    ./neotest.nix
    ./nvim-highlight-colors.nix
    ./nvim-tree.nix
    ./nvim-treesitter.nix
    ./telescope.nix
    ./todo-comments.nix
    ./trouble.nix
    ./vim-sleuth.nix
    ./web-devicons.nix
    ./which-key.nix
  ];
}

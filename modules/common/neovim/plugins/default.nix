{ ... }:
{
  imports = [
    # needs to be loaded early
    ./snacks.nix

    ./blink-cmp.nix
    ./conform.nix
    ./copilot-lua.nix
    ./gitsigns.nix
    ./lsp.nix
    ./lualine.nix
    ./neotest.nix
    ./noice.nix
    ./nvim-highlight-colors.nix
    ./nvim-treesitter.nix
    ./todo-comments.nix
    ./trouble.nix
    ./vim-sleuth.nix
    ./web-devicons.nix
    ./which-key.nix

    # supported languages, loaded last
    ./languages
  ];
}

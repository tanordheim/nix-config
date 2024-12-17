{ ... }:
{
  imports = [
    # needs to be loaded early
    ./snacks.nix

    ./blink-cmp.nix
    ./conform.nix
    ./lspconfig.nix
    ./nvim-tree.nix
    ./nvim-treesitter.nix
    ./telescope.nix
    ./todo-comments.nix
    ./vim-sleuth.nix
    ./which-key.nix
  ];
}

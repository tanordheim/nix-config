{ ... }:
{
  imports = [
    # needs to be loaded early
    ./snacks.nix
    ./mini-icons.nix

    ./blink-cmp.nix
    ./conform.nix
    ./lspconfig.nix
    ./mini-statusline.nix
    ./nvim-tree.nix
    ./nvim-treesitter.nix
    ./telescope.nix
    ./todo-comments.nix
    ./vim-sleuth.nix
    ./which-key.nix
  ];
}

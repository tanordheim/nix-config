{ pkgs, ... }:
{
  # commonly needed libraries
  programs.nixvim = {
    plugins = {
      nui.enable = true;
      blink-pairs.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
    ];
  };

  imports = [
    # needs to be loaded early
    ./snacks.nix
    ./nvim-treesitter.nix

    ./blink-cmp.nix
    ./conform.nix
    ./copilot.nix
    ./lint.nix
    ./dap.nix
    ./gitsigns.nix
    ./lsp.nix
    ./lualine.nix
    ./luasnip
    ./neotest.nix
    ./noice.nix
    ./render-markdown.nix
    ./sidekick.nix
    ./todo-comments.nix
    ./vim-sleuth.nix
    ./web-devicons.nix
    ./which-key.nix

    # supported languages, loaded last
    ./languages
  ];
}

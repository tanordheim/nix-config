{ pkgs, config, ... }:
{
  # commonly needed libraries
  home-manager.users.${config.username}.programs.nixvim = {
    plugins = {
      nui.enable = true;
      dressing.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
    ];
  };

  imports = [
    # needs to be loaded early
    ./snacks.nix
    ./nvim-treesitter.nix

    ./avante.nix
    ./blink-cmp.nix
    ./conform.nix
    ./copilot-lua.nix
    ./dap.nix
    ./gitsigns.nix
    ./grpc-nvim.nix
    ./lensline.nvim
    ./lsp.nix
    ./lualine.nix
    ./luasnip
    ./neotest.nix
    ./noice.nix
    ./nvim-highlight-colors.nix
    ./render-markdown.nix
    ./todo-comments.nix
    ./vim-sleuth.nix
    ./web-devicons.nix
    ./which-key.nix

    # supported languages, loaded last
    ./languages
  ];
}

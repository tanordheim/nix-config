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

    ./avante.nix
    ./blink-cmp.nix
    ./conform.nix
    ./copilot-lua.nix
    ./dap.nix
    ./gitsigns.nix
    ./lsp.nix
    ./lualine.nix
    ./neotest.nix
    ./noice.nix
    ./nvim-highlight-colors.nix
    ./nvim-treesitter.nix
    ./render-markdown.nix
    ./todo-comments.nix
    ./trouble.nix
    ./vim-sleuth.nix
    ./web-devicons.nix
    ./which-key.nix

    # supported languages, loaded last
    ./languages
  ];
}

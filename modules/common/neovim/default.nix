{ inputs, ... }:
{
  home-manager.sharedModules = [
    inputs.nixvim.homeModules.nixvim

    ./colorscheme.nix
    ./diagnostics.nix
    ./keymaps.nix
    ./options.nix
    ./remember-cursor-position.nix

    ./plugins/default.nix
    ./plugins/blink-cmp.nix
    ./plugins/conform.nix
    ./plugins/dap.nix
    ./plugins/gitsigns.nix
    ./plugins/lint.nix
    ./plugins/lsp.nix
    ./plugins/neotest.nix
    ./plugins/nvim-treesitter.nix
    ./plugins/render-markdown.nix
    ./plugins/sidekick.nix
    ./plugins/snacks.nix
    ./plugins/statusline.nix
    ./plugins/tiny-cmdline.nix
    ./plugins/tiny-code-action.nix
    ./plugins/tiny-inline-diagnostic.nix
    ./plugins/todo-comments.nix
    ./plugins/vim-sleuth.nix
    ./plugins/web-devicons.nix
    ./plugins/which-key.nix

    ./plugins/luasnip/default.nix

    ./plugins/languages/lua.nix
    ./plugins/languages/shell.nix
    ./plugins/languages/toml.nix
    ./plugins/languages/yaml.nix

    (
      { config, ... }:
      {
        home.shellAliases = {
          vim = "nvim";
          vi = "nvim";
          vimdiff = "nvim -d";
        };
        programs.nixvim = {
          enable = true;
          defaultEditor = true;

          globals.mapleader = " ";
          plugins.lz-n.enable = true;
          luaLoader.enable = true;
          performance.byteCompileLua = {
            enable = true;
            plugins = true;
          };
        };
        programs.neovide = {
          enable = false;
          settings = {
            font = {
              normal = [ "${config.stylix.fonts.monospace.name}" ];
              size = config.stylix.fonts.sizes.terminal;
            };
          };
        };
      }
    )
  ];
}

{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    globals.autoformat_enabled = true;

    plugins.conform-nvim = {
      enable = true;
      lazyLoad.settings = {
        event = "BufWritePre";
        cmd = "ConformInfo";
      };

      settings = {
        format_after_save = # lua
          ''
            function(bufnr)
              if not vim.g.autoformat_enabled then
                return
              end
              local disable_filetypes = { c = true, cpp = true }
              local lsp_format_opt
              if disable_filetypes[vim.bo[bufnr].filetype] then
                lsp_format_opt = 'never'
              else
                lsp_format_opt = 'fallback'
              end
              return {
                lsp_format = lsp_format_opt,
              }
            end
          '';
      };
    };

    keymaps = [
      {
        key = "<leader>f";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('conform').format { async = true, lsp_fallback = true, lsp_format = 'fallback' }
            end
          '';
        options.desc = "[F]ormat buffer";
      }
      {
        key = "<leader>ft";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              vim.g.autoformat_enabled = not vim.g.autoformat_enabled
              if vim.g.autoformat_enabled then
                vim.notify("Autoformat enabled", vim.log.levels.INFO)
              else
                vim.notify("Autoformat disabled", vim.log.levels.INFO)
              end
            end
          '';
        options.desc = "[F]ormat [T]oggle";
      }
    ];
  };
}

{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
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
    ];
  };
}

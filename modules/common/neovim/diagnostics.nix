{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.extraConfigLua = # lua
    ''
      -- use virtual lines for diagnostic errors and virtual text for diagnostic warnings
      vim.diagnostic.config({
        virtual_text = {
          current_line = true,
          severity = {
            min = vim.diagnostic.severity.INFO,
            max = vim.diagnostic.severity.WARN,
          },
        },
        virtual_lines = {
          current_line = true,
          severity = {
            min = vim.diagnostic.severity.ERROR,
          },
        },
        severity_sort = true
      })
    '';
}

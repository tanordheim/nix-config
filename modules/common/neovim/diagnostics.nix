{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    keymaps = [
      {
        key = "<leader>xo";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              vim.diagnostic.open_float(0, { scope = "line" })
            end
          '';
        options.desc = "Open line diagnostics (float)";
      }
    ];

    extraConfigLua = # lua
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
  };
}

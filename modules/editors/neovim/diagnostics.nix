{
  flake.modules.homeManager.neovim =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.neovim.enable {
        programs.nixvim = {
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
              -- virtual_text is rendered by tiny-inline-diagnostic; keep virtual_lines for errors
              vim.diagnostic.config({
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
      };
    };
}

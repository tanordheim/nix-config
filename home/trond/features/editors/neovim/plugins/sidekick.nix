{ pkgs, config, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      sidekick-nvim
    ];

    extraConfigLua = # lua
      ''
        vim.g.copilot_nes_debounce = 150
        require('sidekick').setup({
          nes = {
            enabled = true,
            debounce = 100,
          },
          cli = {
            tools = {
              claude = { cmd = { "claude" } },
            },
          },
        })
      '';

    keymaps = [
      {
        key = "<Tab>";
        mode = [
          "n"
          "i"
        ];
        action.__raw = # lua
          ''
            function()
              if require("sidekick").nes_jump_or_apply() then
                return
              end
              if vim.b.nes_state then
                local nes = require("copilot-lsp.nes")
                local applied = nes.walk_cursor_start_edit()
                  or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
                if applied ~= nil then
                  return
                end
              end
              return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
            end
          '';
        options = {
          desc = "Sidekick NES apply / Tab fallback";
          expr = true;
        };
      }
      {
        key = "<leader>aa";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("sidekick.cli").toggle({ name = "claude", focus = true })
            end
          '';
        options.desc = "Toggle Claude Code panel";
      }
      {
        key = "<leader>ap";
        mode = [
          "n"
          "v"
        ];
        action.__raw = # lua
          ''
            function()
              require("sidekick.cli").send({ name = "claude" })
            end
          '';
        options.desc = "Send prompt / selection to Claude";
      }
    ];
  };
}

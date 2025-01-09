{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = snacks-nvim;
        type = "lua";
        config = # lua
          ''
            local snacks = require('snacks')

            snacks.setup {
                indent = {
                  enabled = true,
                },
                notifier = {
                  enabled = true,
                },
                statuscolumn = {
                  enabled = true,
                },
            }

            -- show lsp progress
            vim.api.nvim_create_autocmd("LspProgress", {
              ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
              callback = function(ev)
                local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                vim.notify(vim.lsp.status(), "info", {
                  id = "lsp_progress",
                  title = "LSP Progress",
                  opts = function(notif)
                    notif.icon = ev.data.params.value.kind == "end" and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                  end,
                })
              end,
            })

            vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = "[D]elete current [b]uffer" })
            vim.keymap.set('n', '<leader>un', function() Snacks.notifier.hide() end, { desc = "Dismiss all notifications" })
            vim.keymap.set('n', '<leader>uN', function() Snacks.notifier.show_history() end, { desc = "Show notification history" })
            vim.keymap.set('n', '<leader>rN', function() Snacks.rename.rename_file() end, { desc = "[R]e[n]ame File" })
            vim.keymap.set(''\'', '<C-;>', function() Snacks.terminal() end, { desc = "Toggle terminal" })
          '';
      }
    ];
  };
}

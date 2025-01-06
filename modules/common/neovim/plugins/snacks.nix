{ pkgs, config, ... }:
let
  snacks-nvim = (
    pkgs.vimUtils.buildVimPlugin {
      name = "snacks.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "v2.12.0";
        hash = "sha256-bPKN+jawWWO4CTd4z6JoJszylrZ/93vWLJRmr7E2n0c=";
      };
    }
  );

in
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = [
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

            vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = "[D]elete current [b]uffer" })
            vim.keymap.set('n', '<leader>un', function() Snacks.notifier.hide() end, { desc = "Dismiss all notifications" })
            vim.keymap.set('n', '<leader>rN', function() Snacks.rename.rename_file() end, { desc = "[R]e[n]ame File" })
            vim.keymap.set(''\'', '<C-;>', function() Snacks.terminal() end, { desc = "Toggle terminal" })
          '';
      }
    ];
  };
}

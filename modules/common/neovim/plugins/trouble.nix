{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = trouble-nvim;
        type = "lua";
        config = # lua
          ''
            require('trouble').setup {
            }

            vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = "Toggle diagnostics" })
          '';
      }
    ];
  };
}

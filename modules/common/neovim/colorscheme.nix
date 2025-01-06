{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = kanagawa-nvim;
        type = "lua";
        config = # lua
          ''
            local kanagawa = require('kanagawa')
            kanagawa.setup {
              transparent = true,
              dim_inactive = true,
            }
            vim.cmd[[colorscheme kanagawa-dragon]]
          '';
      }
    ];
  };
}

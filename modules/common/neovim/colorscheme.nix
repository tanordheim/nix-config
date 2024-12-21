{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nightfox-nvim;
        type = "lua";
        config = # lua
          ''
            local nightfox = require('nightfox')
            nightfox.setup {
              options = {
                transparent = true,
                dim_inactive = true,
              }
            }
            vim.cmd[[colorscheme ${config.theming.nightfoxStyle}]]
          '';
      }
    ];
  };
}

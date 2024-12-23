{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = mini-icons;
        type = "lua";
        config = # lua
          ''
            require('mini.icons').setup {
            }
            MiniIcons.mock_nvim_web_devicons()
          '';
      }
    ];
  };
}

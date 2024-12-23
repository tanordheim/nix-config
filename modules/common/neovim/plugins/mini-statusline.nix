{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = mini-statusline;
        type = "lua";
        config = # lua
          ''
            require('mini.statusline').setup {
            }
          '';
      }
    ];
  };
}

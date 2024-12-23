{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-highlight-colors;
        type = "lua";
        config = # lua
          ''
            require('nvim-highlight-colors').setup {
            }
          '';
      }
    ];
  };
}

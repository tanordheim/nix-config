{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      nvim-highlight-colors
    ];
    extraConfigLua = # lua
      ''
        require('nvim-highlight-colors').setup {
          renderer = 'virtual';
        }
      '';
  };
}

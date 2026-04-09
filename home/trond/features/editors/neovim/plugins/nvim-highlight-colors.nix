{ pkgs, config, ... }:
{
  programs.nixvim = {
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

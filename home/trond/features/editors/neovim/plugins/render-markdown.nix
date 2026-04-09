{ pkgs, config, ... }:
{
  programs.nixvim.plugins.render-markdown = {
    enable = true;
    lazyLoad = {
      settings = {
        ft = "markdown";
      };
    };
  };
}

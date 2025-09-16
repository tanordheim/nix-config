{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.render-markdown = {
    enable = true;
    lazyLoad = {
      settings = {
        ft = "markdown";
      };
    };
  };
}

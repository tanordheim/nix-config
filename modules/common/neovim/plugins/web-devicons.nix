{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.web-devicons = {
    enable = true;
    lazyLoad = {
      settings = {
        event = "DeferredUIEnter";
      };
    };
  };
}

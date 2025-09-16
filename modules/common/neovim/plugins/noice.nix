{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.noice = {
    enable = true;
    lazyLoad = {
      settings = {
        event = "DeferredUIEnter";
      };
    };
    settings = {
      messages.enabled = false; # using snacks
    };
  };
}

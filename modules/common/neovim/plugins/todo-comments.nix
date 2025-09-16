{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.todo-comments = {
    enable = true;
    lazyLoad = {
      settings = {
        event = "DeferredUIEnter";
      };
    };
  };
}

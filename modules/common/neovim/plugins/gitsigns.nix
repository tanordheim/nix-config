{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.gitsigns = {
    enable = true;
    lazyLoad = {
      settings = {
        event = "DeferredUIEnter";
      };
    };

    settings = {
      current_line_blame = true;
      numhl = true;
    };
  };
}

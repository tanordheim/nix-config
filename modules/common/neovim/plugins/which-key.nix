{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.which-key = {
    enable = true;
  };
}

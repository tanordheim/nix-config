{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.sleuth = {
    enable = true;
  };
}

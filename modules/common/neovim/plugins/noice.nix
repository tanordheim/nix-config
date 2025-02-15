{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.noice = {
    enable = true;
    settings = {
      messages.enabled = false; # using snacks
    };
  };
}

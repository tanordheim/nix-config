{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.lint = {
      enable = true;
    };
  };
}

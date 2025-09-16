{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.lualine = {
    enable = true;
  };
}

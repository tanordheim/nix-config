{ config, ... }:
{
  home-manager.users.${config.username}.programs.eza = {
    enable = true;
    icons = "auto";
    colors = "auto";
  };
}

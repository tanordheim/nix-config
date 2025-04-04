{ config, ... }:
{
  home-manager.users.${config.username}.home.shellAliases = {
    clip = "wl-copy";
    open = "xdg-open";
  };
}

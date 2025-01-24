{ config, ... }:
{
  home-manager.users.${config.username} = {
    programs.zoxide = {
      enable = true;
    };
    home.shellAliases = {
      cd = "z";
    };
  };
}

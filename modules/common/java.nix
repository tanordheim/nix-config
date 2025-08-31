{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.java = {
      enable = true;
    };
  };
}

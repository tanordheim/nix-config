{ config, pkgs, ... }:
{
  users.users.${config.username} = {
    name = config.username;
    description = config.user.fullName;
    home = "/Users/${config.username}";
    shell = pkgs.zsh;
  };
}

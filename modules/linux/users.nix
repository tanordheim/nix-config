{ config, pkgs, ... }:
{
  users.users.${config.username} = {
    name = config.username;
    description = config.user.fullName;
    home = "/home/${config.username}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };
}

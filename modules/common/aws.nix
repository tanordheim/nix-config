{ config, ... }:
{
  home-manager.users.${config.username}.programs.awscli.enable = true;
}

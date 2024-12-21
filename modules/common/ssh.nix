{ config, ... }:
{
  home-manager.users.${config.username}.programs.ssh.enable = true;
}

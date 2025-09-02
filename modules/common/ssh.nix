{ config, ... }:
{
  home-manager.users.${config.username}.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = { };
    matchBlocks."github.com" = {
      host = "github.com";
      hostname = "ssh.github.com";
      port = 443;
    };
  };
}

{ config, ... }:
{
  security.sudo = {
    extraRules = [
      {
        users = [ config.username ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}

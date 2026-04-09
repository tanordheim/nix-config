{ config, lib, ... }:
{
  programs._1password-gui.polkitPolicyOwners = lib.mkIf config.programs._1password-gui.enable [
    "trond"
  ];

  security.sudo.extraRules = [
    {
      users = [ "trond" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}

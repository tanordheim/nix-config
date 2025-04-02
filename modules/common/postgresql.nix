{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    pgcli
  ];

  home-manager.users.${config.username}.xdg.configFile = {
    "pgcli/config" = {
      text = ''
        [main]
        keyring = False
      '';
    };
  };
}

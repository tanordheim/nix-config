{ pkgs, ... }:
{
  imports = [ ../common ];

  home.packages = with pkgs; [
    pgcli
  ];

  xdg.configFile = {
    "pgcli/config" = {
      text = ''
        [main]
        keyring = False
      '';
    };
  };
}

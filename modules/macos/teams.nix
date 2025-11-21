{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.home.packages = with pkgs; [
    teams
  ];
}

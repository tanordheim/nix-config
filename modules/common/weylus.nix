{ pkgs, config, ... }:
{
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [ config.username ];
  };
}

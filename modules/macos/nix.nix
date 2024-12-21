{ config, ... }:
{
  nix.gc = {
    user = config.username;
    interval.Day = 7;
  };

  services.nix-daemon.enable = true;
}

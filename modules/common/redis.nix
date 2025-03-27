{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    redis
  ];
}

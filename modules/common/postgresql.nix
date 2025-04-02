{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pgcli
  ];
}

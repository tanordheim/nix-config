{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    gotools
  ];
}

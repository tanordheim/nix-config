{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    stern
  ];
}

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dolphin
  ];
}

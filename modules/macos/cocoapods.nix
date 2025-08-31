{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cocoapods
  ];
}

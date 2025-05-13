{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    displaylink
  ];
}

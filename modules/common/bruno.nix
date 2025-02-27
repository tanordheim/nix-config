{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bruno
    bruno-cli
  ];
}

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _1password-cli
    _1password-gui
  ];
}

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    asahi-bless
    libnotify
    xdg-utils
  ];
}

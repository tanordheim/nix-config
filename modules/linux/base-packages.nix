{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    asahi-bless
    libnotify
    nvd
    xdg-utils
  ];
}

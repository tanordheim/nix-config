{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    asahi-bless
    libnotify
    nvd
    usbutils
    xdg-utils
  ];
}

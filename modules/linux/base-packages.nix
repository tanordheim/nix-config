{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    asahi-bless
    dos2unix
    libnotify
    nvd
    usbutils
    xdg-utils
  ];
}

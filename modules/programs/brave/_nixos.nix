{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brave
  ];

  my.user.xdg.desktopEntries.brave-browser = {
    exec = "brave --ozone-platform=wayland --js-flags=--no-decommit-pooled-pages";
    icon = "brave";
    name = "Brave";
    terminal = false;
    type = "Application";
  };
}

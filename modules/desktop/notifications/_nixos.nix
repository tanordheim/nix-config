{ pkgs, ... }:
{
  my.user.services.dunst = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      global = {
        monitor = 0;
        width = 500;
        origin = "top right";
        offset = "20x20";
        font = "JetBrainsMono Nerd Font, Medium 12";
      };
    };
  };
}

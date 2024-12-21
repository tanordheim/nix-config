{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        width = 500;
        origin = "top right";
        offset = "20x20";
      };
    };
  };
}

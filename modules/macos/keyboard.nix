{ config, ... }:
{
  home-manager.users.${config.username}.services.macos-remap-keys = {
    enable = true;
    keyboard = {
      Capslock = "Escape";
    };
  };
}

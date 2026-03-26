{ pkgs, config, ... }:
{
  stylix.cursor = {
    size = 24;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };

  home-manager.users.${config.username} = {
    gtk.gtk4.theme = null;
  };
}

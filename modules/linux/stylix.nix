{ pkgs, config, ... }:
{
  stylix.cursor = {
    size = 24;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };
}

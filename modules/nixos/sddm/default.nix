{ config, pkgs, ... }:
let
  sddmTheme = pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    accent = "mauve";
    font = config.stylix.fonts.sansSerif.name;
    fontSize = toString config.stylix.fonts.sizes.applications;
    background = config.stylix.image;
  };
  stylixCursor = config.stylix.cursor;
in
{
  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
      theme = "catppuccin-mocha-mauve";
      extraPackages = [ sddmTheme ];
      settings.Theme = {
        CursorTheme = stylixCursor.name;
        CursorSize = stylixCursor.size;
      };
    };
  };

  environment.systemPackages = [
    sddmTheme
    stylixCursor.package
  ];

  systemd.services.display-manager.environment = {
    XCURSOR_PATH = "${stylixCursor.package}/share/icons";
    XCURSOR_SIZE = toString stylixCursor.size;
    XCURSOR_THEME = stylixCursor.name;
  };
}

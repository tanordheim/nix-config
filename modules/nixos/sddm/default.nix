{ config, pkgs, ... }:
let
  sddmTheme = pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    accent = "mauve";
    font = config.stylix.fonts.sansSerif.name;
    fontSize = toString config.stylix.fonts.sizes.applications;
    background = config.stylix.image;
  };
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
    };
  };

  environment.systemPackages = [ sddmTheme ];
}

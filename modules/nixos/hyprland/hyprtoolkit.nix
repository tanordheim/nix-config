{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        c = config.lib.stylix.colors;
        f = config.stylix.fonts;
      in
      {
        xdg.configFile."hypr/hyprtoolkit.conf".text = ''
          background = 0xFF${c.base00}
          base = 0xFF${c.base01}
          alternate_base = 0xFF${c.base02}
          text = 0xFF${c.base05}
          bright_text = 0xFF${c.base07}
          link_text = 0xFF${c.base0D}
          accent = 0xFF${c.base0E}
          accent_secondary = 0xFF${c.base0D}

          font_family = ${f.sansSerif.name}
          font_family_monospace = ${f.monospace.name}
          font_size = ${toString f.sizes.applications}
        '';
      }
    )
  ];
}

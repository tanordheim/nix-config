{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;
      in
      {
        home.packages = [ pkgs.bleeding.hyprlauncher ];

        xdg.configFile."hyprlauncher/config.json".source =
          (pkgs.formats.json { }).generate "hyprlauncher-config.json" {
            window = {
              use_gtk_colors = false;
              show_border = true;
              border_width = 2;
            };
            theme.colors = {
              border = c.base0E;
              window_bg = c.base00;
              search_bg = c.base01;
              search_bg_focused = c.base02;
              item_bg = c.base00;
              item_bg_hover = c.base02;
              item_bg_selected = c.base03;
              search_text = c.base05;
              search_caret = c.base0E;
              item_name = c.base05;
              item_name_selected = c.base07;
              item_description = c.base04;
              item_description_selected = c.base04;
              item_path = c.base03;
              item_path_selected = c.base03;
            };
          };
      }
    )
  ];
}

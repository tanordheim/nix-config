{
  sherlock,
  config,
  pkgs,
  ...
}:
{
  home-manager.users.${config.username} =
    { config, lib, ... }:
    let
      colors = config.lib.stylix.colors;
      rgb-to-hsl =
        color:
        let
          r = ((lib.toInt config.lib.stylix.colors."${color}-rgb-r") * 100.0) / 255;
          g = ((lib.toInt config.lib.stylix.colors."${color}-rgb-g") * 100.0) / 255;
          b = ((lib.toInt config.lib.stylix.colors."${color}-rgb-b") * 100.0) / 255;
          max = lib.max r (lib.max g b);
          min = lib.min r (lib.min g b);
          delta = max - min;
          fmod = base: int: base - (int * builtins.floor (base / int));
          h =
            if delta == 0 then
              0
            else if max == r then
              60 * (fmod ((g - b) / delta) 6)
            else if max == g then
              60 * (((b - r) / delta) + 2)
            else if max == b then
              60 * (((r - g) / delta) + 4)
            else
              0;
          l = (max + min) / 2;
          s = if delta == 0 then 0 else 100 * delta / (100 - lib.max (2 * l - 100) (100 - (2 * l)));
          roundToString = value: toString (builtins.floor (value + 0.5));
        in
        "${roundToString h}, ${roundToString s}%, ${roundToString l}%";
    in
    {
      imports = [
        sherlock.homeManagerModules.default
      ];
      programs.sherlock = {
        enable = true;
        settings = {
          launchers = [
            {
              name = "Calculator";
              type = "calculation";
              args = {
                capabilities = [
                  "calc.math"
                  "calc.units"
                ];
              };
              priority = 1;
            }
            {
              name = "App Launcher";
              type = "app_launcher";
              args = { };
              priority = 1;
              home = true;
            }
          ];
          config = {
            debug = {
              try_suppress_errors = false;
              try_suppress_warnings = false;
            };
            units = {
              lengths = "meter";
              weights = "kg";
              volumes = "l";
              temperatures = "C";
            };
            appearance = {
              width = 600;
              height = 400;
              gsk_renderer = "cairo";
              icon_size = 22;
              status_bar = false;
              use_base_css = true;
            };
            behavior = {
              animate = false;
              caching = true;
            };
          };
          style = # css
            ''
              /*
               * This theme depends on the base css. You need to have the config key `use_base_css` set to `true`.
              */

              :root {
                  /* backgrounds */ 
                  --background: ${rgb-to-hsl "base00"}; /* default background */
                  --border: ${rgb-to-hsl "base0D"}; /* focused window border */
                  --text: ${rgb-to-hsl "base05"}; /* default text */
                  --text-active: ${rgb-to-hsl "base00"}; /* default background */

                  --tag-background: ${rgb-to-hsl "base02"}; /* selection background */

                  /* foreground */
                  --foreground: ${rgb-to-hsl "base0E"}; /* mauve */

                  /* accent colors */
                  --error: ${rgb-to-hsl "base08"}; /* error */
                  --success: ${rgb-to-hsl "base09"}; /* urgent */
                  --warning: ${rgb-to-hsl "base0A"}; /* warning */
              }

              /* Will make icons inside active tile black else white */
              #search-icon-holder image,
              image.reactive {
                  -gtk-icon-filter: brightness(10) saturate(100%) contrast(100%); /* white */
              }
              row:selected .tile image.reactive {
                  -gtk-icon-filter: brightness(0) saturate(100%) contrast(100%); /* black */
              }

              /* Custom search icon animation */
              #search-icon-holder image {
                  transition: 0.1s ease;
              }
              #search-icon-holder.search image:nth-child(1){
                  transition-delay: 0.05s;
                  opacity: 1;
              }
              #search-icon-holder.search image:nth-child(2){
                  transform: rotate(-180deg);
                  opacity: 0;
              }
              #search-icon-holder.back image:nth-child(1){
                  opacity: 0;
              }
              #search-icon-holder.back image:nth-child(2){
                  transition-delay: 0.05s;
                  opacity: 1;
              }


              row:selected .tile #title {
                  color: hsla(var(--text-active), 0.7);
              }

              row:selected .tile .tag,
              .tag {
                  font-size: 11px;
                  border-radius: 3px;
                  padding: 2px 8px;
                  color: hsl(var(--tag-color));
                  box-shadow: 0px 0px 10px 0px hsla(var(--background), 0.2);
                  border: 1px solid hsla(var(--text-active), 0.2);
                  margin-left: 7px;
              }

              row:selected .tile .tag-start,
              row:selected .tile .tag-start {
                  background: hsla(var(--tag-background), 0.7);
              }

              row:selected .tile .tag-end,
              row:selected .tile .tag-end
              {
                  background: hsla(var(--success), 1);
              }

              .tile:focus {
                  outline: none;
              }

              #launcher-type {
                  font-size: 10px;
                  color: hsla(var(--text), 0.4);
                  margin-left: 0px;
              }
              row:selected .tile #launcher-type {
                  color: hsla(var(--text-active), 0.4);
              }

              /*SHORTCUT*/
              #shortcut-holder {
                  box-shadow: unset;
              }
              #shortcut-holder label {
                  color: hsla(var(--text-active), 0.5);
              }

              /* BULK TEXT TILE */
              .bulk-text {
                  padding-bottom: 10px;
                  min-height: 50px;
              }

              #bulk-text-title {
                  margin-left: 10px;
                  padding: 10px 0px;
                  font-size: 10px;
                  color: gray;
              }

              #bulk-text-content-title {
                  font-size: 17px;
                  font-weight: bold;
                  color: hsla(var(--text-active), 0.7);
                  min-height: 20px;
              }

              #bulk-text-content-body {
                  font-size: 14px;
                  color: hsla(var(--text-active), 0.7);
                  line-height: 1.4;
                  min-height: 20px;
              }

              /*EVENT TILE*/
              .tile.event-tile:selected #time-label,
              .tile.event-tile:selected #title-label{
                  color: hsla(var(--text-active), 0.6);
              } 

              /* NEXT PAGE */
              .next_tile {
                  color: hsl(var(--text-active));
                  background: hsl(var(--background));
              }
              .next_tile #content-body {
                  background: hsl(var(--background));
                  padding: 10px;
                  color: hsl(var(--text));
              }
              .raw_text, .next_tile #content-body {
                  font-family: 'Fira Code', monospace;
                  font-feature-settings: "kern" off;
                  font-kerning: None;
              }
            '';
        };
      };
    };
}

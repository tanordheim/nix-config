{ config, ... }:
{
  home-manager.users.${config.username}.programs.alacritty = {
    enable = true;
    settings = {
      font = with config.stylix.fonts; {
        bold = {
          family = monospace.name;
          style = "Bold";
        };
        italic = {
          family = monospace.name;
          style = "Italic";
        };
        bold_italic = {
          family = monospace.name;
          style = "Bold Italic";
        };
      };
      keyboard = {
        bindings = [
          {
            key = "<";
            mods = "Control|Shift";
            action = "IncreaseFontSize";
          }
          {
            key = ">";
            mods = "Control|Shift";
            action = "DecreaseFontSize";
          }
          {
            key = "?";
            mods = "Control|Shift";
            action = "ResetFontSize";
          }
        ];
      };
      window = {
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}

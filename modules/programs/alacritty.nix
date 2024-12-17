{ ... }:
{
  my.user.programs.alacritty = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      font =
        let
          fontFamily = "JetBrainsMono Nerd Font";
        in
        {
          normal = {
            family = fontFamily;
            style = "Regular";
          };
          bold = {
            family = fontFamily;
            style = "Bold";
          };
          italic = {
            family = fontFamily;
            style = "Italic";
          };
          bold_italic = {
            family = fontFamily;
            style = "Bold Italic";
          };
          size = 14.0;
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
        opacity = 0.95;
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}

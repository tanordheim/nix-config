{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        programs.hyprlock = {
          enable = true;
          package = pkgs.bleeding.hyprlock;
          settings = {
            general.hide_cursor = true;
            background = {
              blur_passes = 3;
              blur_size = 8;
            };
            input-field = {
              size = "300, 60";
              outline_thickness = "4";
              dots_size = "0.2";
              dots_spacing = "0.2";
              dots_center = "true";
              fade_on_empty = false;
              placeholder_text = "$USER";
              hide_input = false;
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              position = "0, -47";
              halign = "center";
              valign = "center";
            };
          };
        };
      }
    )
  ];
}

{
  pkgs,
  config,
  hyprlock,
  ...
}:
let
  facePath = config.user.image;

in
{
  home-manager.users.${config.username} =
    { lib, config, ... }:
    let
      colors = config.lib.stylix.colors;
    in
    {
      programs.hyprlock = {
        enable = true;
        package = hyprlock.packages.${pkgs.system}.default;

        #   settings = {
        #     general = {
        #       hide_cursor = true;
        #     };
        #
        #     background = {
        #       blur_passes = 3;
        #       blur_size = 8;
        #     };
        #
        #     label = [
        #       {
        #         text = "$TIME";
        #         # color = colors.withHashtag.base05;
        #         font_size = config.stylix.fonts.sizes.applications * 7;
        #         font_family = config.stylix.fonts.sansSerif.name;
        #         position = "-30, 0";
        #         halign = "right";
        #         valign = "top";
        #       }
        #       {
        #         text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
        #         # color = colors.withHashtag.base05;
        #         font_size = config.stylix.fonts.sizes.applications * 2;
        #         font_family = config.stylix.fonts.sansSerif.name;
        #         position = "-30, -150";
        #         halign = "right";
        #         valign = "top";
        #       }
        #     ];
        #
        #     image = {
        #       path = "${config.lib.file.mkOutOfStoreSymlink facePath}";
        #       size = "100";
        #       # border_color = colors.withHashtag.base0E;
        #       position = "0, 75";
        #       halign = "center";
        #       valign = "center";
        #     };
        #
        #     input-field = {
        #       size = "300, 60";
        #       outline_thickness = "4";
        #       dots_size = "0.2";
        #       dots_spacing = "0.2";
        #       dots_center = "true";
        #       fade_on_empty = false;
        #       placeholder_text = "$USER";
        #       hide_input = false;
        #       fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        #       # capslock_color = colors.withHashtag.base0A;
        #       position = "0, -47";
        #       halign = "center";
        #       valign = "center";
        #     };
        #   };
      };

      wayland.windowManager.hyprland.settings.bind = [
        "$mainMod $altMod, L, exec, hyprlock"
      ];
    };
}

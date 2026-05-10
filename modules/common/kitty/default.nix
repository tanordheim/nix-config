{
  home-manager.sharedModules = [
    (
      { lib, pkgs, ... }:
      {
        programs.kitty = {
          enable = true;

          settings = {
            update_check_interval = 0;
            scrollback_lines = 10000;
            cursor_shape = "underline";
            clear_all_shortcuts = true;
            paste_actions = "quote-urls-at-prompt,confirm-if-large";
            tab_bar_style = "hidden";
          };

          keybindings = {
            "ctrl+shift+k" = "change_font_size all +1";
            "ctrl+shift+j" = "change_font_size all -1";
            "ctrl+shift+n" = "change_font_size all 0";
            "ctrl+a>q" = "load_config_file";
          }
          // lib.optionalAttrs pkgs.stdenv.isDarwin {
            "cmd+c" = "copy_and_clear_or_interrupt";
            "cmd+v" = "paste_from_clipboard";
            "cmd+q" = "quit";
          }
          // lib.optionalAttrs pkgs.stdenv.isLinux {
            "ctrl+c" = "copy_and_clear_or_interrupt";
            "ctrl+shift+v" = "paste_from_clipboard";
          };
        };
      }
    )
  ];
}

{
  home-manager.sharedModules = [
    (
      { lib, pkgs, ... }:
      {
        programs.kitty = {
          enable = true;

          settings = {
            update_check_interval = 0;
            # kitty's auto-reload watcher (0.47+) follows the nix-store symlink and
            # kqueue-watches every entry under /nix/store, leaking 100k+ FDs → "too many
            # open files". 0.47.2's non-recursive fix is insufficient (store root has 150k+
            # direct entries). 0 disables it; rebuild+restart replaces the config anyway, and
            # ctrl+a>q (load_config_file) still reloads manually.
            auto_reload_config = 0;
            scrollback_lines = 10000;
            cursor_shape = "underline";
            clear_all_shortcuts = true;
            paste_actions = "quote-urls-at-prompt,confirm-if-large";
            tab_bar_style = "hidden";
            mouse_hide_wait = 3.0;
          }
          // lib.optionalAttrs pkgs.stdenv.isDarwin {
            window_padding_width = 8;
            hide_window_decorations = "titlebar-only";
            text_composition_strategy = "1.0 0";
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
            "cmd+shift+k" = "change_font_size all +1";
            "cmd+shift+j" = "change_font_size all -1";
            "cmd+shift+n" = "change_font_size all 0";
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

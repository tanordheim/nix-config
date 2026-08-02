let
  nerdRanges = "U+E000-U+E00A,U+E0C0-U+E0C8,U+E0CA,U+E0CC-U+E0D7,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6B7,U+E700-U+E8EF,U+EA60-U+EC1E,U+ED00-U+EDFF,U+EE0C-U+EF00,U+EF03-U+EF05,U+EF13-U+EFCE,U+F000-U+F381,U+F400-U+F533,U+F0001-U+F1AF0";
  codiconExtrasRange = "U+EC81-U+EC82";
in
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
            # direct entries). auto_reload_config is a debounce interval (s); a NEGATIVE value
            # disables the watcher entirely. rebuild+restart replaces the config anyway, and
            # ctrl+a>q (load_config_file) still reloads manually.
            auto_reload_config = -1;
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

          extraConfig = ''
            symbol_map ${nerdRanges} JetBrainsMono Nerd Font Mono
            symbol_map ${codiconExtrasRange} Codicon Extras Mono
            narrow_symbols ${nerdRanges},${codiconExtrasRange} 1
          '';

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

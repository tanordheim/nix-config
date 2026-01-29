{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.kitty = {
    enable = true;

    settings = {
      update_check_interval = 0;
      scrollback_lines = 10000;
      cursor_shape = "underline";
      clear_all_shortcuts = true;
      paste_actions = "quote-urls-at-prompt,confirm-if-large";
    };

    keybindings = {
      "ctrl+shift+i" = "change_font_size all +1";
      "ctrl+shift+m" = "change_font_size all -1";
      "ctrl+shift+n" = "change_font_size all 0";
      "ctrl+a>q" = "load_config_file";
      "ctrl+a>c" = "new_tab_with_cwd";
      "ctrl+a>x" = "close_tab";
      "ctrl+a>m" = "previous_tab";
      "ctrl+a>i" = "next_tab";
      "ctrl+a>1" = "goto_tab 1";
      "ctrl+a>2" = "goto_tab 2";
      "ctrl+a>3" = "goto_tab 3";
      "ctrl+a>4" = "goto_tab 4";
      "ctrl+a>5" = "goto_tab 5";
      "ctrl+a>6" = "goto_tab 6";
      "ctrl+a>7" = "goto_tab 7";
      "ctrl+a>8" = "goto_tab 8";
      "ctrl+a>9" = "goto_tab 9";
      "ctrl+a>0" = "goto_tab 10";
      "ctrl+a>KP_1" = "goto_tab 1";
      "ctrl+a>KP_2" = "goto_tab 2";
      "ctrl+a>KP_3" = "goto_tab 3";
      "ctrl+a>KP_4" = "goto_tab 4";
      "ctrl+a>KP_5" = "goto_tab 5";
      "ctrl+a>KP_6" = "goto_tab 6";
      "ctrl+a>KP_7" = "goto_tab 7";
      "ctrl+a>KP_8" = "goto_tab 8";
      "ctrl+a>KP_9" = "goto_tab 9";
      "ctrl+a>KP_0" = "goto_tab 10";
      "shift+enter" = "send_text all \\n"; # for shift+enter in claude code
    };
  };
}

{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.kitty = {
    enable = true;

    settings = {
      update_check_interval = 0;
      scrollback_lines = 10000;
      cursor_shape = "underline";
      clear_all_shortcuts = true;
    };

    keybindings = {
      "cmd+c" = "copy_and_clear_or_interrupt";
      "cmd+v" = "paste_from_clipboard";
      "ctrl+shift-i" = "change_font_size all +1";
      "ctrl+shift-m" = "change_font_size all -1";
      "ctrl+shift+n" = "change_font_size all 0";
      "ctrl+a>c" = "new_tab";
      "ctrl+a>x" = "close_tab";
      "ctrl+a>m" = "goto_tab -1";
      "ctrl+a>i" = "goto_tab 1";
      "ctrl+a>1" = "select_tab 1";
      "ctrl+a>2" = "select_tab 2";
      "ctrl+a>3" = "select_tab 3";
      "ctrl+a>4" = "select_tab 4";
      "ctrl+a>5" = "select_tab 5";
      "ctrl+a>6" = "select_tab 6";
      "ctrl+a>7" = "select_tab 7";
      "ctrl+a>8" = "select_tab 8";
      "ctrl+a>9" = "select_tab 9";
      "ctrl+a>0" = "select_tab 10";
    };
  };
}

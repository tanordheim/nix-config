{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.kitty = {
    enable = true;
    settings = {
      clear_all_shortcuts = true;
      confirm_os_window_close = 0;
      disable_ligatures = "always";
      enable_audio_bell = false;
    };

    keybindings = {
      "ctrl+c" = "copy_and_clear_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+," = "change_font_size all -1.0";
      "ctrl+shift+." = "change_font_size all +1.0";
      "ctrl+shift+/" = "change_font_size all 0";
    };
  };
}

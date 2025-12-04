{ config, ... }:
{
  home-manager.users.${config.username}.programs.kitty.keybindings = {
    "cmd+c" = "copy_and_clear_or_interrupt";
    "cmd+v" = "paste_from_clipboard";
  };
}

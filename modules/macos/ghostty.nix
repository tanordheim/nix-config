{ config, pkgs, ... }:
{
  home-manager.users.${config.username}.programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    clearDefaultKeybinds = true;
    enableZshIntegration = true;
    settings = {
      scrollback-limit = 64000000;
      shell-integration-features = true;
      cursor-style = "underline";
      cursor-style-blink = true;
      selection-clear-on-copy = true;
      clipboard-trim-trailing-spaces = true;
      clipboard-paste-protection = false;
      working-directory = "home";
      window-inherit-working-directory = true;
      auto-update = "off";
      keybind = [
        "cmd+c=copy_to_clipboard"
        "cmd+v=paste_from_clipboard"
        "cmd+q=quit"
        # "ctrl+shift+>=increase_font_size:1"
        # "ctrl+shift+<=decrease_font_size:1"
        # "ctrl+shift+?=reset_font_size"
        "ctrl+a>c=new_tab"
        "ctrl+a>x=close_tab"
        "ctrl+a>t=previous_tab"
        "ctrl+a>n=next_tab"
        "ctrl+a>1=goto_tab:1"
        "ctrl+a>2=goto_tab:2"
        "ctrl+a>3=goto_tab:3"
        "ctrl+a>4=goto_tab:4"
        "ctrl+a>5=goto_tab:5"
        "ctrl+a>6=goto_tab:6"
        "ctrl+a>7=goto_tab:7"
        "ctrl+a>8=goto_tab:8"
        "ctrl+a>9=goto_tab:9"
        "ctrl+a>0=goto_tab:10"
      ];
    };
  };
}

{
  home-manager.sharedModules = [
    {
      programs.ghostty = {
        enable = true;

        settings = {
          alpha-blending = "native";
          cursor-style = "underline";
          gtk-tabs-location = "hidden";
          confirm-close-surface = false;
          mouse-hide-while-typing = true;
          shell-integration-features = "ssh-terminfo";
          app-notifications = "no-clipboard-copy,no-config-reload,no-prefix-key";

          keybind = [
            "ctrl+shift+k=increase_font_size:1"
            "ctrl+shift+j=decrease_font_size:1"
            "ctrl+shift+n=reset_font_size"
            "ctrl+space>q=reload_config"
          ];
        };
      };
    }
  ];
}

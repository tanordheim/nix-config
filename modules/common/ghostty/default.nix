{ lib, isDarwin, ... }:
{
  imports = [ (lib.mkPlatformImport ./. isDarwin) ];

  home-manager.sharedModules = [
    {
      programs.ghostty = {
        enable = true;

        settings = {
          cursor-style = "underline";
          confirm-close-surface = false;
          mouse-hide-while-typing = true;
          shell-integration-features = "ssh-terminfo";
          app-notifications = false;

          keybind = [
            "ctrl+shift+k=increase_font_size:1"
            "ctrl+shift+j=decrease_font_size:1"
            "ctrl+shift+n=reset_font_size"
            "ctrl+shift+comma=reload_config"
          ];
        };
      };
    }
  ];
}

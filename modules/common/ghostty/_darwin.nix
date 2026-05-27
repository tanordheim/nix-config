{
  homebrew.casks = [ "ghostty" ];

  home-manager.sharedModules = [
    {
      programs.ghostty.package = null;
      programs.ghostty.settings = {
        font-size = 15;
        macos-titlebar-style = "hidden";
        window-padding-x = 8;
        window-padding-y = 8;

        keybind = [
          "cmd+shift+k=increase_font_size:1"
          "cmd+shift+j=decrease_font_size:1"
          "cmd+shift+n=reset_font_size"
        ];
      };
    }
  ];
}

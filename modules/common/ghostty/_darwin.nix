{
  homebrew.casks = [ "ghostty" ];

  home-manager.sharedModules = [
    {
      programs.ghostty.package = null;
      programs.ghostty.settings = {
        macos-option-as-alt = true;

        keybind = [
          "cmd+shift+k=increase_font_size:1"
          "cmd+shift+j=decrease_font_size:1"
          "cmd+shift+n=reset_font_size"
        ];
      };
    }
  ];
}

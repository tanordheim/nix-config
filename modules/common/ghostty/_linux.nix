{
  home-manager.sharedModules = [
    {
      programs.ghostty.settings = {
        alpha-blending = "native";
        gtk-tabs-location = "hidden";
        keybind = [
          "performable:alt+c=copy_to_clipboard"
          "alt+v=paste_from_clipboard"
        ];
      };
    }
  ];
}

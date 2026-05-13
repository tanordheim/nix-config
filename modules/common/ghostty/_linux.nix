{
  home-manager.sharedModules = [
    {
      programs.ghostty.settings = {
        alpha-blending = "native";
        gtk-tabs-location = "hidden";
      };
    }
  ];
}

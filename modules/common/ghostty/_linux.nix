{
  home-manager.sharedModules = [
    {
      programs.ghostty.settings = {
        alpha-blending = "linear";
        gtk-tabs-location = "hidden";
      };
    }
  ];
}

{
  home-manager.sharedModules = [
    {
      programs.eza = {
        enable = true;
        icons = "auto";
        colors = "auto";
      };
    }
  ];
}

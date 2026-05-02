{
  users.users.trond = {
    home = "/Users/trond";
  };

  system.primaryUser = "trond";

  home-manager.sharedModules = [
    {
      home.homeDirectory = "/Users/trond";
    }
  ];
}

{ pkgs, ... }:
{
  users.users.trond = {
    name = "trond";
    description = "Trond Nordheim";
    home = "/Users/trond";
    shell = pkgs.zsh;
  };

  system.primaryUser = "trond";

  home-manager.sharedModules = [
    {
      home.homeDirectory = "/Users/trond";
    }
  ];
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.trond = {
    name = "trond";
    description = "Trond Nordheim";
    home = if pkgs.stdenv.isDarwin then "/Users/trond" else "/home/trond";
    shell = pkgs.zsh;
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    isNormalUser = true;
    extraGroups = [ "wheel" ] ++ ifTheyExist [ "docker" ];
  };

  home-manager.users.trond = {
    imports = [ ../../../home/trond/${config.networking.hostName}.nix ];
    home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/trond" else "/home/trond";
    xdg = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      mimeApps.enable = true;
    };
  };
}

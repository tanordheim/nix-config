{
  home-manager.sharedModules = [
    (
      { lib, pkgs, ... }:
      {
        programs.home-manager.enable = true;
        services.ssh-agent.enable = lib.mkIf pkgs.stdenv.isLinux true;
      }
    )
  ];
}

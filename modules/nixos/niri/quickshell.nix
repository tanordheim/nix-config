{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      {
        programs.quickshell.configs.niri = import ../quickshell/config.nix {
          inherit config pkgs;
          desktop = ./quickshell;
          logoutSession = [
            "${pkgs.niri}/bin/niri"
            "msg"
            "action"
            "quit"
          ];
        };
      }
    )
  ];
}

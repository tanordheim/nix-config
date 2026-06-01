{ lib, isDarwin, ... }:
{
  home-manager.sharedModules = [
    {
      programs.zsh.initContent = ''
        bindkey '^[r' atuin-search
      '';

      programs.atuin = {
        enable = true;
        enableZshIntegration = true;
        daemon.enable = true;
        flags = [
          "--disable-up-arrow"
        ];
        settings = {
          sync_address = "https://atuin.home.nordheim.io";
          sync_frequency = "5m";
          style = "compact";
          inline_height = 25;
          show_preview = true;
          show_help = false;
          enter_accept = false;
          filter_mode = "global";
        };
      };
    }
  ]
  ++ lib.optional isDarwin (
    { config, pkgs, ... }:
    {
      launchd.agents.atuin-daemon.config.ProgramArguments = lib.mkForce [
        "/bin/sh"
        "-c"
        "/bin/wait4path /nix/store && /bin/rm -f ${config.xdg.dataHome}/atuin/daemon.sock && exec ${lib.getExe pkgs.atuin} daemon start"
      ];
    }
  );
}

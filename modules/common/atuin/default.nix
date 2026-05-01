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
          history_filter = [
            "^.*(API_KEY|SECRET|TOKEN|PASSWORD)="
            "^op (run|read)"
          ];
          style = "compact";
          inline_height = 1;
          show_preview = false;
          show_help = false;
          enter_accept = false;
          filter_mode = "global";
        };
      };
    }
  ];
}

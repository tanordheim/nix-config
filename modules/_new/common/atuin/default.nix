{
  home-manager.sharedModules = [
    {
      programs.zsh.initContent = ''
        bindkey '^[r' atuin-search
      '';

      programs.atuin = {
        enable = true;
        enableZshIntegration = true;
        flags = [
          "--disable-up-arrow"
          "--disable-ctrl-r"
        ];
        settings = {
          sync_address = "https://atuin.home.nordheim.io";
          sync_frequency = "5m";
          history_filter = [
            "^.*(API_KEY|SECRET|TOKEN|PASSWORD)="
            "^op (run|read)"
          ];
          style = "compact";
          inline_height = 25;
          show_preview = true;
          show_help = false;
          enter_accept = false;
          filter_mode = "global";
        };
      };
    }
  ];
}

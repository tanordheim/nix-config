{
  flake.modules.homeManager.atuin =
    {
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf config.host.features.atuin.enable {
        programs.atuin = {
          enable = true;
          enableZshIntegration = true;
          flags = [ "--disable-up-arrow" ];
          settings = {
            sync_address = "https://atuin.home.nordheim.io";
            sync_frequency = "5m";
            history_filter = [
              "^.*(API_KEY|SECRET|TOKEN|PASSWORD)="
              "^op (run|read)"
            ];
          };
        };
      };
    };
}

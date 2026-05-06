{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        stylix.targets.firefox.profileNames = [ "default" ];
        programs.firefox = {
          enable = true;
          policies = {
            DisableTelemetry = true;
            PasswordManagerEnabled = false;
            DownloadDirectory = "${config.home.homeDirectory}/Downloads";
            UseSystemPrintDialog = true;
            Preferences = {
              "privacy.globalprivacycontrol.enabled" = {
                Value = true;
                Status = "locked";
              };
            };
          };
        };
      }
    )
  ];
}

{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    commandLineArgs = [
      "--oauth2-client-id=77185425430.apps.googleusercontent.com"
      "--oauth2-client-secret=OTJgUOQcT7lO7GsGZq2G4IlT"
    ];
    extensions = [
      # 1Password
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa"

      # Detrumpify
      "hfhaalldkgmfbjjehkiddheghljjdjln"

      # Feedly Notifier
      "egikgfbhipinieabdmcpigejkaomgjgb"
    ];
  };
}

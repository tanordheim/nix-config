{ pkgs, config, ... }:
{
  stylix.fonts.sizes.terminal = 15;

  homebrew.casks = [
    "desktoppr"
  ];

  launchd.user.agents.stylixwallpaper = {
    serviceConfig = {
      Label = "set-stylix-wallpaper";
      ProgramArguments = [
        "/opt/homebrew/bin/desktoppr"
        (toString config.stylix.image)
      ];
      RunAtLoad = true;
      StandardOutPath = "/tmp/set-stylix-wallpaper.log";
      StandardErrorPath = "/tmp/set-stylix-wallpaper.error.log";
    };
  };
}

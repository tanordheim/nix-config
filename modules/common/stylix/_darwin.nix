{ inputs, ... }:
{
  imports = [ inputs.stylix.darwinModules.stylix ];

  stylix.fonts.sizes.terminal = 15;

  homebrew.casks = [ "desktoppr" ];

  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        launchd.agents.stylixwallpaper = {
          enable = true;
          config = {
            Label = "set-stylix-wallpaper";
            ProgramArguments = [
              "/usr/local/bin/desktoppr"
              (toString config.stylix.image)
            ];
            RunAtLoad = true;
            StandardOutPath = "/tmp/set-stylix-wallpaper.log";
            StandardErrorPath = "/tmp/set-stylix-wallpaper.error.log";
          };
        };
      }
    )
  ];
}

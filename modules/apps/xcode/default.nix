{
  flake.modules.darwin.xcode =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.xcode.enable {
        homebrew.brews = [ "xcode-kotlin" ];
      };
    };

  flake.modules.homeManager.xcode =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.xcode.enable {
        home.file."Library/Developer/Xcode/UserData/FontAndColorThemes/Catppuccin Mocha.xccolortheme" = {
          source = ./themes/Catppuccin_Mocha.xccolortheme;
        };
      };
    };
}

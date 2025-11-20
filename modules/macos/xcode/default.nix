{ config, pkgs, ... }:
{
  homebrew.masApps = {
    Xcode = 497799835;
  };

  homebrew.brews = [
    "xcode-kotlin"
  ];

  home-manager.users.${config.username}.home.file."Library/Developer/Xcode/UserData/FontAndColorThemes/Catppuccin Mocha.xccolortheme" =
    {
      source = ./themes/Catppuccin_Mocha.xccolortheme;
    };
}

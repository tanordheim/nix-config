{
  homebrew.brews = [ "xcode-kotlin" ];

  home-manager.sharedModules = [
    {
      home.file."Library/Developer/Xcode/UserData/FontAndColorThemes/Catppuccin Mocha.xccolortheme" = {
        source = ./themes/Catppuccin_Mocha.xccolortheme;
      };
    }
  ];
}

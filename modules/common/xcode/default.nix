{
  homebrew.brews = [
    "xcode-kotlin"
    "swiftformat"
    "swiftlint"
  ];

  home-manager.sharedModules = [
    {
      home.file."Library/Developer/Xcode/UserData/FontAndColorThemes/Catppuccin Mocha.xccolortheme" = {
        source = ./themes/Catppuccin_Mocha.xccolortheme;
      };
    }
  ];
}

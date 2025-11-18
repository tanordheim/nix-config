{ pkgs, ... }:
{
  homebrew.masApps = {
    Xcode = 497799835;
  };

  homebrew.brews = [
    "xcode-kotlin"
  ];
}

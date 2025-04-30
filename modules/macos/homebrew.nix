{
  config,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = config.username;
    autoMigrate = true;
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}

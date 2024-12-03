{
  config,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  ...
}: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = config.d.user.name;
    autoMigrate = true;
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
  };
}

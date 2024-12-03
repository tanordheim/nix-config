{
  inputs,
  userConfig,
  ...
}: {
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "${userConfig.name}";
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };
}

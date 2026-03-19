{ ... }:
final: prev: {
  roslyn-ls = prev.roslyn-ls.override {
    # override the .net SDK dependencies to use prebuilt binaries instead of source packages to not have installing roslyn-ls take 7 years
    dotnetCorePackages = prev.dotnetCorePackages // {
      sdk_8_0 = prev.dotnetCorePackages.sdk_8_0-bin;
      sdk_9_0 = prev.dotnetCorePackages.sdk_9_0-bin;
      sdk_10_0 = prev.dotnetCorePackages.sdk_10_0-bin;
    };
  };
}

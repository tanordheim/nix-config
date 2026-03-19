{ ... }:
final: prev: {
  roslyn-ls = prev.roslyn-ls.override {
    dotnet-sdk =
      with prev.dotnetCorePackages;
      sdk_10_0-bin
      // {
        inherit
          (combinePackages [
            sdk_9_0-bin
            sdk_8_0-bin
          ])
          packages
          targetPackages
          ;
      };
  };
}

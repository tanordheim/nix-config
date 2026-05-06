{ pkgs, ... }:
let
  androidSdk =
    (pkgs.androidenv.composeAndroidPackages {
      numLatestPlatformVersions = 3;
      buildToolsVersions = [
        "35.0.0"
        "36.0.0"
        "37.0.0"
      ];
      includeEmulator = false;
      includeNDK = false;
      includeSources = false;
      includeSystemImages = false;
    }).androidsdk;
  androidHome = "${androidSdk}/libexec/android-sdk";
in
{
  nixpkgs.config.android_sdk.accept_license = true;

  home-manager.sharedModules = [
    {
      home.packages = [
        pkgs.android-studio
        androidSdk
      ];
      home.sessionVariables = {
        ANDROID_HOME = androidHome;
        ANDROID_SDK_ROOT = androidHome;
      };
    }
  ];
}

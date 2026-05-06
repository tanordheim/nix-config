{ pkgs, ... }:
let
  androidSdk =
    (pkgs.androidenv.composeAndroidPackages {
      platformVersions = [
        "35"
        "34"
      ];
      buildToolsVersions = [ "34.0.0" ];
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

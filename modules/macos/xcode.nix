{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cocoapods
  ];

  homebrew.brews = [
    "xcode-kotlin"
  ];
}

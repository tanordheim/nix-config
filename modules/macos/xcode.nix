{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cocoapods
  ];

  homebrew.casks = [
    "xcode-kotlin"
  ];
}

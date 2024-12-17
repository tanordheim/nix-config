{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    asahi-bless
  ];

  imports = [
    ../common
    ./bluetooth.nix
    ./keyboard.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = config.d.stateVersion;
}

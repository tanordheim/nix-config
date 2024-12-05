{ ... }:
{
  imports = [
    ./desktop
    ./programs
    ./security
    ./system
    ./window-manager

    ./aws.nix
    ./config.nix
    ./shells.nix
  ];
}

{ pkgs, ... }:
{
  imports = [
    ./openssh.nix
  ];

  environment.systemPackages = [
    pkgs.kitty.terminfo
  ];
}

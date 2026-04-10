{ pkgs, lib, ... }:
{
  imports = [
    ../features/cli
    ../features/stylix.nix
  ];

  programs.home-manager.enable = true;

  services.ssh-agent.enable = lib.mkIf pkgs.stdenv.isLinux true;
}

{ pkgs, config, ... }:
{
  programs.nixvim.plugins.sleuth = {
    enable = true;
  };
}

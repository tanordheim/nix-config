{
  pkgs,
  lib,
  config,
  ...
}:
{
  home-manager.users.${config.username} =
    { config, ... }:
    {
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        # set <space> as the leader key; this must happen before anything else
        globals.mapleader = " ";
      };
      programs.neovide = {
        enable = true;
        settings = {
        };
      };
    };

  imports = [
    ./colorscheme.nix
    ./keymaps.nix
    ./options.nix
    ./diagnostics.nix
    ./remember-cursor-position.nix
    ./plugins
  ];
}

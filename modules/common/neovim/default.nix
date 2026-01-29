{
  pkgs,
  lib,
  nixvim,
  config,
  ...
}:
{
  home-manager.users.${config.username} =
    { config, ... }:
    {
      imports = [
        nixvim.homeModules.nixvim
      ];
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        # set <space> as the leader key; this must happen before anything else
        globals.mapleader = " ";

        # facilitates lazy loading
        plugins.lz-n.enable = true;
      };
      programs.neovide = {
        enable = false;
        settings = {
          font = {
            normal = [ "${config.stylix.fonts.monospace.name}" ];
            size = config.stylix.fonts.sizes.terminal;
          };
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

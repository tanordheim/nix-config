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
      stylix.targets.neovim.enable = false;
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        # set <space> as the leader key; this must happen before anything else
        extraLuaConfig = # lua
          ''
            vim.g.mapleader = ' '
            vim.g.maplocalleader = ' '
          '';

        # core plugins used by various other plugins
        plugins = with pkgs.vimPlugins; [
          plenary-nvim
          nvim-web-devicons
        ];
      };
    };

  imports = [
    ./colorscheme.nix
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];
}

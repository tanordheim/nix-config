{ pkgs, lib, ... }:
{
  my.user =
    { config, ... }:
    {
      programs.neovim = {
        enable = true;
        catppuccin.enable = true;
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
    ./options.nix
    ./keymaps.nix
    ./plugins
  ];
}

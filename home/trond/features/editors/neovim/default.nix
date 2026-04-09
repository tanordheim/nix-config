{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  home.shellAliases = {
    vim = "nvim";
    vi = "nvim";
    vimdiff = "nvim -d";
  };

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./colorscheme.nix
    ./keymaps.nix
    ./options.nix
    ./diagnostics.nix
    ./remember-cursor-position.nix
    ./plugins
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # set <space> as the leader key; this must happen before anything else
    globals.mapleader = " ";

    # facilitates lazy loading
    plugins.lz-n.enable = true;

    luaLoader.enable = true;
    performance.byteCompileLua = {
      enable = true;
      plugins = true;
    };
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
}

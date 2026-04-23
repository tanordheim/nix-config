{ inputs, ... }:
{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        inputs.nixvim.homeModules.nixvim
      ];

      config = lib.mkIf config.host.features.neovim.enable {
        home.shellAliases = {
          vim = "nvim";
          vi = "nvim";
          vimdiff = "nvim -d";
        };
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
      };
    };
}

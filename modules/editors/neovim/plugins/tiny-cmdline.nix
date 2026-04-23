{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf config.host.features.neovim.enable {
        programs.nixvim = {
          extraPlugins = with pkgs.vimPlugins; [
            tiny-cmdline-nvim
          ];

          opts.cmdheight = 0;

          extraConfigLua = # lua
            ''
              require('tiny-cmdline').setup({})
            '';
        };
      };
    };
}

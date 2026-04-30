{
      pkgs,
      lib,
      config,
      ...
    }:
    {
      
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
      
    }

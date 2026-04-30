{
      pkgs,
      lib,
      config,
      ...
    }:
    {
      
        programs.nixvim = {
          extraPlugins = with pkgs.vimPlugins; [
            tiny-code-action-nvim
          ];

          extraConfigLua = # lua
            ''
              require('tiny-code-action').setup({
                backend = "vim",
                picker = "snacks",
              })
            '';

          keymaps = [
            {
              key = "gra";
              mode = [
                "n"
                "x"
              ];
              action.__raw = # lua
                ''
                  function()
                    require("tiny-code-action").code_action()
                  end
                '';
              options = {
                desc = "Code action";
                silent = true;
              };
            }
          ];
        };
      
    }

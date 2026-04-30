{
      pkgs,
      lib,
      config,
      ...
    }:
    {
      
        programs.nixvim = {
          extraPlugins = with pkgs.vimPlugins; [
            blink-compat
          ];

          plugins.blink-cmp = {
            enable = true;

            settings = {
              keymap = {
                preset = "default";
              };
              appearance = {
                use_nvim_cmp_as_default = true;
                nerd_font_variant = "mono";
              };
              completion = {
                trigger.show_in_snippet = false;
                menu.border = "rounded";
                documentation.window.border = "rounded";
              };
              signature = {
                enabled = true;
                window.border = "rounded";
              };
              snippets.preset = "luasnip";

              sources = {
                default = [
                  "lsp"
                  "path"
                  "snippets"
                ];
              };
            };
          };
        };
      
    }

{ pkgs, config, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      blink-cmp-copilot
      blink-compat
    ];

    plugins.blink-cmp = {
      enable = true;

      settings = {
        keymap = {
          preset = "super-tab";
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
            "copilot"
            "snippets"
          ];
          providers = {
            copilot = {
              async = true;
              module = "blink-cmp-copilot";
              name = "copilot";
              score_offset = 100;
            };
          };
        };
      };
    };
  };
}

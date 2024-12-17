{ pkgs, ... }:
{
  my.user.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      luasnip
      friendly-snippets
      {
        plugin = blink-cmp;
        type = "lua";
        config = # lua
          ''
            local blink = require('blink.cmp')

            blink.setup {
              -- 'default' for mappings similar to built-in completion
              -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
              -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
              -- see the "default configuration" section below for full documentation on how to define
              -- your own keymap.
              keymap = { preset = 'super-tab' },

              appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
              },

              completion = {
                trigger = {
                  show_in_snippet = false
                },
              },

              -- default list of enabled providers defined so that you can extend it
              -- elsewhere in your config, without redefining it, via `opts_extend`
              sources = {
                default = { 'lsp', 'path', 'buffer', 'snippets' },
                -- optionally disable cmdline completions
                -- cmdline = {},
              },

              -- experimental signature help support
              signature = { enabled = true },
            }

            vim.keymap.set('i', '<C-Space>', function() blink.show() end)
          '';
      }
    ];
  };
}
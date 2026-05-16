{ lib, config, ... }:
    {
      
        programs.nixvim = {
          keymaps = [
            {
              key = "<BS>";
              mode = "n";
              action = "<C-^>";
              options.desc = "Switch to alternate buffer";
            }
            {
              key = "p";
              mode = "v";
              action = ''"_dP'';
              options.desc = "Paste without clobbering clipboard";
            }
            {
              key = "<";
              mode = "v";
              action = "<gv";
              options.desc = "Indent left and reselect";
            }
            {
              key = ">";
              mode = "v";
              action = ">gv";
              options.desc = "Indent right and reselect";
            }
            {
              key = "<CR>";
              mode = "n";
              action = "<cmd>nohlsearch<cr>";
              options.desc = "Clear search highlights";
            }
            {
              key = "[b";
              mode = "n";
              action = "<cmd>bprev<cr>";
              options.desc = "Go to the previous buffer";
            }
            {
              key = "]b";
              mode = "n";
              action = "<cmd>bnext<cr>";
              options.desc = "Go to the next buffer";
            }
            {
              key = "U";
              mode = "n";
              action = "<C-r>";
              options.desc = "Redo";
            }
          ];

          extraConfigLua = # lua
            ''
              -- Highlight when yanking (copying) text
              vim.api.nvim_create_autocmd('TextYankPost', {
                desc = 'Highlight when yanking (copying) text',
                group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
                callback = function()
                  vim.hl.on_yank()
                end,
              })
            '';
        };
      
    }

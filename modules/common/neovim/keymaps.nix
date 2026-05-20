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

        vim.api.nvim_create_user_command('CopyRelPath', function()
          local file = vim.fn.expand('%:p')
          if file == "" then
            vim.notify('No file in current buffer', vim.log.levels.WARN)
            return
          end
          local dir = vim.fn.fnamemodify(file, ':h')
          local root = vim.fn.systemlist({ 'git', '-C', dir, 'rev-parse', '--show-toplevel' })[1]
          local path
          if vim.v.shell_error == 0 and root and root ~= "" then
            path = vim.fn.fnamemodify(file, ':p'):sub(#root + 2)
          else
            path = vim.fn.fnamemodify(file, ':.')
          end
          vim.fn.setreg('+', path)
          vim.notify('Copied: ' .. path)
        end, { desc = 'Copy repo-relative path of current file to clipboard' })
      '';
  };

}

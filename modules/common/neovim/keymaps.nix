{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    keymaps = [
      {
        key = "<CR>";
        mode = "n";
        action = "<cmd>nohlsearch<cr>";
        options.desc = "Clear search highlights";
      }
      {
        key = "<C-Left>";
        mode = "n";
        action = "<C-w><C-h>";
        options.desc = "Move focus to the left window";
      }
      {
        key = "<C-h>";
        mode = "n";
        action = "<C-w><C-h>";
        options.desc = "Move focus to the left window";
      }
      {
        key = "<C-Right>";
        mode = "n";
        action = "<C-w><C-l>";
        options.desc = "Move focus to the right window";
      }
      {
        key = "<C-l>";
        mode = "n";
        action = "<C-w><C-l>";
        options.desc = "Move focus to the right window";
      }
      {
        key = "<C-Down>";
        mode = "n";
        action = "<C-w><C-j>";
        options.desc = "Move focus to the lower window";
      }
      {
        key = "<C-j>";
        mode = "n";
        action = "<C-w><C-j>";
        options.desc = "Move focus to the lower window";
      }
      {
        key = "<C-Up>";
        mode = "n";
        action = "<C-w><C-k>";
        options.desc = "Move focus to the upper window";
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<C-w><C-k>";
        options.desc = "Move focus to the upper window";
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
    ];

    extraConfigLua = # lua
      ''
        -- Highlight when yanking (copying) text
        vim.api.nvim_create_autocmd('TextYankPost', {
          desc = 'Highlight when yanking (copying) text',
          group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
          callback = function()
            vim.highlight.on_yank()
          end,
        })
      '';
  };
}

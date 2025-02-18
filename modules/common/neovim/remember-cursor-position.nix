{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.extraConfigLua = # lua
    ''
      local cursor_group = vim.api.nvim_create_augroup("RememberCursor", {})
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = cursor_group,
        pattern = "*",
        callback = function()
          local last_pos = vim.fn.line "'\""
          if last_pos > 1 and last_pos <= vim.fn.line "$" then
            vim.cmd 'normal! g`"'
            vim.cmd "normal zz"
          end
        end,
      })
    '';
}
